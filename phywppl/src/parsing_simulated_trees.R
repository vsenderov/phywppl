# Configuration -----------------------------------------------------------
# comes from executing script
# Example
#directory = "C:/Users/vsend/GoogleDrive/Work/exp-anads/wip-4/AnaDS2-prior-predictive"
#metadata_file = "AnaDS2-prior-predictive-results.JSON"
#trees_dir = "AnaDS2-prior-predictive.js.trees"
#tree_prefix = "tree_simulations_AnaDS2-prior-predictive_"
#tree_postfix = ".js.trees"
#filename = "outdata.Rdata"




# Functions ---------------------------------------------------------------


digs = function(x, k = 2) {
  format(round(x, 2), nsmall = k)
}

#' Validate trees among possible cases
#' 
#'  - valid tree
#'  - guards
#'  - bo Survivors
#'
#' @param trees  A list of string containing possible Newick trees
#' @param pattern1  No survivors regexp
#' @param pattern2  Guards regexp
#'
#' @return  A character vector with valid trees
#' @export
#' 
valid_trees = function(trees, pattern1 = "^No", pattern2 = "^Guards") {
  na.omit(sapply(trees, function(tree) {
    if(grepl(pattern1, tree)[1] || grepl(pattern2, tree)[1]) {
      return(NA)
    } else return(tree)
  }))
}

#' Find zero trees
#'
#' @param trees  A list of strings containing possible Newick trees
#' @param pattern  No survivors regexp
#'
#' @return  The number of zero node trees founds
#' @export
#'
zero_trees = function(trees, pattern = "^No") {
  sum(sapply(trees, function(tree) {
    if(grepl(pattern, tree)[1]) {
      return(TRUE)
    } else return(FALSE)
  }))
}


setwd(directory)

# Metadata and Outer loop -------------------------------------------------
# this is time consuming, output cached in phylo list

json_object = rjson::fromJSON(
  file = file.path(directory,  metadata_file),
  method = "C")
nexperiments = length(json_object)

phylo = list()
for (i in 1:nexperiments) {
  # Read trees and process trees
  trees = strsplit(readLines(file.path(trees_dir, paste0(tree_prefix, json_object[[i]]$label, ".js.trees") )), "\\n")
  full_trees =  gsub("[ ]+", "", valid_trees(trees))
  number_empty_trees = zero_trees(trees)
  number_max_trees = zero_trees(trees, pattern = "^Guards")
  
  # Phylogenetics
  phylogenetic_trees = list()
  for (j in 1:length(full_trees)) {
    phylogenetic_trees[[j]] = read.newick(text = full_trees[j])
    cat(paste(i, j, "\n"))
  }
  phylo[[i]] = phylogenetic_trees
}
  
nodedata = list()
gammadata = list()
for (i in 1:nexperiments) {
  cat(paste(i, "\n"))
  phylogenetic_trees = phylo[[i]]
  node_distribution = sapply(phylogenetic_trees, function(pt) { pt$Nnode - 1}) # exclude the root
  nodedata[[i]] = rbind(data.frame("N" = node_distribution, "Treatment" = "Experiment"),
                        data.frame("N" = rnbinom(length(node_distribution), size = 1, mu = mean(node_distribution)), "Treatment" = paste0("NegativeBinomial(", digs(mean(node_distribution)), ")")))
  gamma_distribution = sapply(phylogenetic_trees, function(pt){ gammatest(ltt(pt))$gamma }) # the gamma stat value for each tree in the experiment
  gammadata[[i]] = data.frame("Gamma" = unlist(gamma_distribution))
}

save(json_object, phylo, nodedata, gammadata, file = filename)


#annotate("text", label = extract_parameter_string2(json_object[[i]]$parameters), x = 5) +
#annotate("text", label = paste0("mean = ", digs(nodes_mean), "\n", "\n", "max = ", digs(nodes_max)), x = 7.5)


#  nodes_mean_star = mean(node_distribution[node_distribution < MAX_NUMNODES_PLOT])
# 
# K[[i]] = nlevels(as.factor(node_distribution))
# node_distribution  = sapply(levels(as.factor(node_distribution)), function(N) {
#   sum(node_distribution == N)
# }) 
# 
# qdata = rbind(
#   data.frame("N" = names(node_distribution), "Count" = node_distribution)
# )
# qdata$N = as.integer(qdata$N)
# qdata$Frequency = qdata$Count / sum(qdata$Count)
# qdata$Treatment = "Experiment"
# 
# pdata = data.frame(N = 0:MAX_NUMNODES_PLOT, Frequency = dnbinom(0:MAX_NUMNODES_PLOT, size = 1, mu = nodes_mean_star), Treatment = paste0("Nbinom(1, ", digs(nodes_mean_star), ")"), Count = NA)
# 
# final_data = rbind(qdata, pdata)
# 
# plots[[i]] = ggplot(data = final_data, aes(x = N, y = Frequency, fill = Treatment)) + 
#   geom_bar(stat = "identity", position = position_dodge()) + 
#   annotate("text", label = extract_parameter_string2(json_object[[i]]$parameters), x = 5, y = 0.6) + 
#   annotate("text", label = paste0("mean = ", digs(nodes_mean), "\n", "mean_* = ", digs(nodes_mean_star), "\n", "max = ", digs(nodes_mean_max)), x = 12, y = 0.6) + 
#   xlab("Number of nodes") + 
#   xlim(-0.5, MAX_NUMNODES_PLOT) + ylim(0,1) + 
#   geom_line( stat = "smooth", size = 1.5, alpha = 0.75, aes(col = Treatment), se = FALSE, method="loess", formula = 'y ~ x') +
#   #ggtitle(TeX(paste(length(phylo[[i]]), "trees,",  extract_parameter_string(json_object[[i]]$parameters)))) 
#   ggtitle(TeX(paste(length(phylo[[i]]), "trees,", "$T = ", json_object[[i]]$parameters$startTime, ", \\delta = ", json_object[[i]]$parameters$stepsize, "$")))  