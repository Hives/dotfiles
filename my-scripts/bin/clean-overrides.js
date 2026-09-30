#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const packageJsonPath = path.join(process.cwd(), 'package.json');

if (!fs.existsSync(packageJsonPath)) {
  console.error('❌ Error: No package.json found in the current directory.');
  process.exit(1);
}

const packageJson = JSON.parse(fs.readFileSync(packageJsonPath, 'utf8'));

if (!packageJson.overrides || Object.keys(packageJson.overrides).length === 0) {
  console.log('ℹ️ No overrides field found in package.json. Nothing to clean.');
  process.exit(0);
}

console.log('🔍 Evaluating active overrides...');
let changed = false;

try {
  const queryOutput = execSync('npm query ":overridden"', {
    encoding: 'utf8',
    stdio: ['ignore', 'pipe', 'ignore']
  });

  const activeOverrides = JSON.parse(queryOutput || '[]');
  const activeOverrideNames = new Set(activeOverrides.map(node => node.name));

  for (const key of Object.keys(packageJson.overrides)) {
    let isDoingSomething = activeOverrideNames.has(key);

    if (!isDoingSomething && typeof packageJson.overrides[key] === 'object' && packageJson.overrides[key] !== null) {
      const subKeys = Object.keys(packageJson.overrides[key]).filter(k => k !== '.');
      isDoingSomething = subKeys.some(subKey => activeOverrideNames.has(subKey));
    }

    if (!isDoingSomething) {
      console.log(`  ❌ Removing dead override: "${key}"`);
      delete packageJson.overrides[key];
      changed = true;
    } else {
      console.log(`  ✅ Keeping active override: "${key}"`);
    }
  }

  if (Object.keys(packageJson.overrides).length === 0) {
    delete packageJson.overrides;
    changed = true;
  }

  if (changed) {
    fs.writeFileSync(packageJsonPath, JSON.stringify(packageJson, null, 2) + '\n', 'utf8');
    console.log('\n✨ Done! Dead overrides removed from package.json.');
  } else {
    console.log('\n✨ All overrides are active and necessary.');
  }
} catch (error) {
  console.error('  ⚠️ Could not verify overrides. Ensure your node_modules are fully installed first.');
}
