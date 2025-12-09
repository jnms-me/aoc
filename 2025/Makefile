all: index.wasm

index.wasm: *.scm */*.scm
	guild compile-wasm -L. --bundle -oindex.wasm index.scm

clean:
	rm -f *.wasm reflect.js

serve: all
	guile -c '((@ (hoot web-server) serve))'

.PHONY: all clean serve
