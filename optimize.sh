#!/bin/sh

set -e

js="elm.js"
min="elm.min.js"

elm make --optimize --output=$js "$@"

uglifyjs elm.js --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,passes=2,unsafe_comps,unsafe' | uglifyjs --mangle --output elm.min.js
# npx terser elm.js --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' | npx terser --mangle --output elm.min.js



echo "Compiled size:$(wc $js -c) bytes  ($js)"
echo "Minified size:$(wc $min -c) bytes  ($min)"
echo "Gzipped size: $(gzip $min -c | wc -c) bytes"
