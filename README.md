# dc-minio

MinIO S3-compatible object storage (API on port 9000, Console on port 9001).

## Quick start

```bash
cp .env.sample .env
vim .env
make up
```

## Commands

### Lifecycle

```
make d          # deploy (git pull + recreate)
make r          # recreate (build + stop + up)
make up         # start
make stop       # stop
make down       # stop and remove
make ps         # status
make l          # follow logs
```

### MinIO

```
make minio-shell      # sh shell in minio container
make minio-buckets    # list buckets
make minio-health     # check health endpoint
make test             # run smoke tests (health, bucket init)
```

## Console

Open http://localhost:9001 — MinIO web console.

## Init

On first `make up`, `minio-init` container creates the default bucket (from `MINIO_DEFAULT_BUCKET` env var) with public download policy.
