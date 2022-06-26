from google.cloud import datastore


def chunk_list(l, n):
    for i in range(0, len(l), n):
        yield l[i:i + n]


client = datastore.Client(namespace="stubs-index-data-cacher", project="jl-digital-merch-flex")
batch_size = 500

kinds = [ 'Product' ]

for kind in kinds:

    query = client.query(kind=kind)
    query.keys_only()

    results = list(query.fetch())

    result_keys = [r.key for r in results]

    i = 0
    for chunk in chunk_list(result_keys, batch_size):
        client.delete_multi(chunk)
        i += 1
        print(f"Number of entities deleted from {kind} = {i * batch_size}")


