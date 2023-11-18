#!/usr/bin/env bash
set -euo pipefail

JOMPOSE_FILE=${JOMPOSE_FILE:-docker-jompose.jsonnet}

[ -f "${JOMPOSE_FILE}" ] || {
	printf "Jompose file doesn't found: %s\n" "${JOMPOSE_FILE}"
	false # Fail.
}

RENDERED_PATH="${PWD}/.jompose/rendered"
mkdir -p "$RENDERED_PATH"

processJomposeFile() {
	printf "
(import 'jompose.libsonnet')(
	local jompose = import 'jompose-helpers.libsonnet';
%s
)
	" "$(while IFS= read -r line; do printf "\t%s\n" "${line}"; done <"${1}")"
}

jsonnet \
	-S -J @jomposeStd@ \
	<(processJomposeFile "${JOMPOSE_FILE}") \
	-m "${RENDERED_PATH}" >/dev/null

# shellcheck source=/dev/null
. "${RENDERED_PATH}/.env"

docker compose \
	--project-directory "$PWD" \
	-f "${RENDERED_PATH}/${COMPOSE_FILE?:Compose file is not set (broken std?)}" \
	-p "${COMPOSE_PROJECT_NAME:?Project name is not set (broken std?)}" \
	"${@}"
