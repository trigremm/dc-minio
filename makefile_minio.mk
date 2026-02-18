# makefile_minio.mk
# MinIO commands (all run inside Docker, no host dependencies)

.PHONY: minio-shell minio-buckets minio-health test

minio-shell:
	$(DC_BIN) exec minio sh

minio-buckets:
	$(DC_BIN) run --rm minio-init /bin/sh -c "mc alias set minio http://minio:9000 $${MINIO_ROOT_USER} $${MINIO_ROOT_PASSWORD}; mc ls minio/"

minio-health:
	curl -fsS http://localhost:$${DC_MINIO_API_PORT:-9000}/minio/health/ready && echo "OK"

test:
	@echo "Starting minio..."
	$(DC_BIN) up -d
	@echo "Waiting for healthcheck..."
	@for i in 1 2 3 4 5 6; do \
		curl -fsS http://localhost:$${DC_MINIO_API_PORT:-9000}/minio/health/ready >/dev/null 2>&1 && break || sleep 3; \
	done
	@echo "Test health..."
	curl -fsS http://localhost:$${DC_MINIO_API_PORT:-9000}/minio/health/ready > /dev/null && echo "PASS: health" || (echo "FAIL: health" && exit 1)
	@echo "Test bucket init..."
	$(DC_BIN) run --rm minio-init /bin/sh -c "mc alias set minio http://minio:9000 $${MINIO_ROOT_USER} $${MINIO_ROOT_PASSWORD}; mc ls minio/$${MINIO_DEFAULT_BUCKET:-uploads}" > /dev/null && echo "PASS: bucket exists" || (echo "FAIL: bucket" && exit 1)
	@echo ""
	@echo "All tests passed!"
