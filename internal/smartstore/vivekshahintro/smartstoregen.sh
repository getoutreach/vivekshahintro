#!/usr/bin/env bash

# if Smartstore Codegen fails, do not continue
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
REPODIR="${DIR}/../../.."
SMARTSTORE_VER="$(go list -m -f "{{ .Version }}" github.com/getoutreach/smartstore || true)"

# If we're in development against a branch of smartstore,
# the version will be a pseudo-version which is not an actual commit-ish that we can git checkout
# https://go.dev/doc/modules/gomod-ref#require-syntax
# This will convert the pseudo-version into just the commit hash, e.g.:
#    v0.0.0-20200921210052-fa0125251cc4 -> fa0125251cc4
PSEUDO_VER_HASH=$(echo "${SMARTSTORE_VER}" | cut -d- -f3)
if [[ -n $PSEUDO_VER_HASH && $PSEUDO_VER_HASH != "$SMARTSTORE_VER" ]]; then
  echo "Converting Go module pseudo-version to hash: ${SMARTSTORE_VER} -> ${PSEUDO_VER_HASH}"
  SMARTSTORE_VER=$PSEUDO_VER_HASH
fi

echo "Executing Smartstore Code Generator, SMARTSTORE_VER=${SMARTSTORE_VER}"
exec "${REPODIR}/scripts/shell-wrapper.sh" gobin.sh "github.com/getoutreach/smartstore/cmd/smartstore@${SMARTSTORE_VER}" --skip-update codegen --cfg "${DIR}/codegen.yml"
