all: clean build run

build:
	@echo "Building the project..."
	dune build

run:
	@echo "Running the project..."
	dune exec ./_build/default/src/main.exe -- $(ARG)

clean:
	@echo "Cleaning up..."
	dune clean || true # Ignore errors if Dune fails
	rm -rf _build
