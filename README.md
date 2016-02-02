# CPython
D bindings for CPython, taken from https://github.com/ariovistus/pyd, all credit goes to the `pyd` authors.

Run `genDubConfig.py "<your project name>"` with your chosen python interpreter to print an example dub.json with the relevant library paths etc. set correctly.

I suggest doing this even if you don't intend to use `dub`, the output should contain the necessary information for you to use your own build tool (e.g. `version` flags)

## Examples
To run an example, do something like this:

```sh
cd examples/example
python3 ../../genDubConfig example > dub.json
dub build
python3 test.py
```
