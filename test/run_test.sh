#!/usr/bin/env bash

set -eo pipefail

echo "Checking Soundex.mo compiles"
$(vessel bin)/moc $(vessel sources) ../src/Soundex.mo

$(vessel bin)/moc $(vessel sources) -wasi-system-api SoundexTest.mo
if wasmtime SoundexTest.wasm ; then
    echo "Tests passed"
    exit 1
else
    echo "Tests failed"
    exit 0
fi