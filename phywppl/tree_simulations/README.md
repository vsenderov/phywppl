# Simulating phylogenetic trees in WebPPL

To simulate phylogenetic trees in WebPPL, the following models are available: 
-CRB
-CRBD (extinctions are removed from the tree)
-CRBD-full (extinctions are retained in the tree)

-ToDo: Clads0-2

### Pre-requisite: Installing webppl-fs

An package `webppl-fs` is needed to write the trees to files. 
Full installation instructions can be found here: 
https://github.com/null-a/webppl-fs

To locally install webppl-fs, run:
    npm install webppl-fs

### Running tree simulation
1. Choose model from the ones available in the tree_simulations directory
2. If the model includes extinction, optionally change mu in the treesim file. The default is 0.05.
3. Run simulation (from phywppl directory):
    npm run wppl tree_simulations/treesim-crb.wppl [N] [OUTPUTFILE] [TREEAGE] [LAMBDA]
    
    Example:
    npm run wppl tree_simulations/treesim-crb.wppl 1 "tree_simulations/Output/test1.txt" 10 0.2

