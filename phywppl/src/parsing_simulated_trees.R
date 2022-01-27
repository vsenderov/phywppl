# Input
library(rjson)
json_object = rjson::fromJSON(
  file = "/Users/vsend/Desktop/AnaDS2-prior-predictive-results.JSON",
  method = "C")
trees = strsplit(json_object[[1]]$output, "\\n")  # After this operation trees
  # is a list of one character vector, containing the many trees.
  # Some trees are "No survivors"
survivors = !(trees[[1]] == "No survivors")
non_zero_trees = trees[[1]][survivors]
length(non_zero_trees)

# Need to put parenthesis around the trees
repaired_trees = gsub(";$", ");", paste0("(", non_zero_trees))[-1384]

# Phylogenetics
library(phytools)
phylogenetic_trees = list()
for (i in 1:length(repaired_trees)) {
  phylogenetic_trees[[i]] = read.newick(text = repaired_trees[i])
  cat(i)
}


node_distribution = sapply(phylogenetic_trees, function(pt) { pt$Nnode })
