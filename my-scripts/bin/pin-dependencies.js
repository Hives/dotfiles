#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const packageJsonPath = path.join(process.cwd(), 'package.json');

if (!fs.existsSync(packageJsonPath)) {
  console.error('❌ Error: No package.json found in the current directory.');
  process.exit(1);
}

const packageJson = JSON.parse(fs.readFileSync(packageJsonPath, 'utf8'));
let changed = false;

console.log('🔄 Scanning node_modules to match exact versions...');

const pinToInstalledVersions = (field) => {
  if (!packageJson[field]) return;

  for (const pkg of Object.keys(packageJson[field])) {
    const pkgPath = path.join(process.cwd(), 'node_modules', pkg, 'package.json');

    if (fs.existsSync(pkgPath)) {
      try {
        const pkgInfo = JSON.parse(fs.readFileSync(pkgPath, 'utf8'));
        const actualVersion = pkgInfo.version;

        if (actualVersion && packageJson[field][pkg] !== actualVersion) {
          console.log(`  🔹 [${field}] ${pkg}: ${packageJson[field][pkg]} ➡️ ${actualVersion}`);
          packageJson[field][pkg] = actualVersion;
          changed = true;
        }
      } catch (e) {
        console.error(`  ⚠️ Could not parse package.json for ${pkg}:`, e.message);
      }
    } else {
      console.warn(`  ⚠️ Warning: ${pkg} is listed in ${field} but is not currently installed.`);
    }
  }
};

pinToInstalledVersions('dependencies');
pinToInstalledVersions('devDependencies');

if (changed) {
  fs.writeFileSync(packageJsonPath, JSON.stringify(packageJson, null, 2) + '\n', 'utf8');
  console.log('\n✨ Done! package.json has been updated with exact installed versions.');
} else {
  console.log('\n✨ All versions are already perfectly pinned.');
}
