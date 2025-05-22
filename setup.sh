#!/usr/bin/env bash

bun upgrade
bun i
bun run build

pushd packages/cli
npm link
popd

echo "elizaos version: $(elizaos --version)"
