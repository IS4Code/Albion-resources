This is an unofficial repository of up-to-date Albion game resources, including fan-made translations. It can be used to construct the corresponding XLD data files in the original game, or as a modification loaded by ports.

If you want to contribute with fixes, feel free to create a pull request.

## Building

To build the XLDLIBS directory, simply clone the repository and build it using GNU `make`:

* `make` or `make all` ‒ builds the whole XLDLIBS directory for all languages.
* `make base` ‒ builds only files directly in XLDLIBS.
* `make initial` ‒ builds only files in XLDLIBS/INITIAL.
* `make lang` ‒ builds all localized files.
* `make lang1`/`2`/`3` ‒ builds only `XLDLIBS/GERMAN`/`ENGLISH`/`FRENCH`.

You may also build only specific output files, such as via `make XLDLIBS/ITEMNAME.DAT`.
