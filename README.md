# Phylogenetic models in WebPPL

To install and use the models in WebPPL, the following packages have been provided:

  * [phywppl](phywppl/phywppl/README.md) main package containing the models (implemented in WebPPL)
  * [phyjs](phywppl/phyjs/README.md) dependency package with shared library functions (implemented in JavaScript)

### Installing phylogenetic WebPPL (phywppl)

An npm package `phywppl` has been provided. To install it:

1. Download and install [Node](https://nodejs.org/en/download/), if it has not been installed already.
2. Download and install [WebPPL](http://docs.webppl.org/en/master/installation.html), if it has not been installed already.
3. Download this repository (see above), if it has not been downloaded already.
4. Change to the `phywppl/phywppl` package directory:

```
cd phywppl/phywppl
```

5. Install dependency packages `phyjs` (local) and `shelljs`:

```
npm install ../phyjs
npm install shelljs
```

Now, all WebPPL programs from the paper can be run from the shell with the tools that are found in the repository. Consult the [phywppl README](phywppl/phywppl/README.md) for instructions.
