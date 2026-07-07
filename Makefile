# Makefile
# Load and export .env so host-side recipes can reference vars like
# $${MINIO_ROOT_USER} / $${MINIO_ROOT_PASSWORD}. Guarded so `make` still
# works when no .env is present (mirrors dc-traefik's include/export approach).
ifneq (,$(wildcard .env))
include .env
export
endif

include makefile_docker_compose.mk
include makefile_minio.mk
