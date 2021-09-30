# https://cran.r-project.org/web/packages/spectralAnalysis/index.html
#https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0198311

if(!require(pacman))install.packages("pacman")
pacman::p_load("ggplot2", "cowplot", "plot3D", "GCalignR")

args <- commandArgs(trailingOnly = TRUE)

load2GCalign <- function(dr) {
    fls <- dir(dr)
    fls <- fls[grep(".csv", fls)]
    raw_table <- list()
    for(i in 1:length(fls)){
        raw_table[[i]] <- read.csv(paste0(dr, fls[i]), check.names=FALSE)[,c(2,4)]
    }
    raw_table <- do.call(cbind, raw_table)
    return(raw_table)
}


plot3D <- function(data) {
    if (is(data)[1] =="list"){
        lines3D(data[[1]]@mass,
        	rep(1, length(data[[i]]@mass)),
                data[[2]]@intensity,
                col=1,
                ylim=c(0, length(data)))
        for(i in 2:length(data)){ 
            lines3D(data[[i]]@mass,
            	rep(i, length(data[[i]]@mass)),
                    data[[i]]@intensity,
                    col=i,
                    ylim=c(0, length(data)), add=TRUE)
        }
    } else if (is(data)[1] =="data.frame"){
        lines3D(data[,1],
        	rep(1, nrow(data)),
                data[,2],
                col=1,
                ylim=c(0, ncol(data)))
        for(i in seq(3, ncol(data), by=2)){ 
            lines3D(raw_table[,i],
            	rep(i, nrow(raw_table)),
                    raw_table[,i+1],
                    col=i,
                    ylim=c(0, ncol(data)), add=TRUE)
        }
    }
}

plotSpec <- function(raw_table, idx){
    sq <- seq(1, ncol(data), by=2)
    c1 <- sq[idx]
    c2 <- sq[idx]+1
    plot(raw_table[,c1], raw_table[,c2], "l")
}

raw2GCalign <- function(fls, raw_table, fname){
    write.table(matrix(sub('.csv', '', fls), ncol=3), quote = FALSE, 
    	    file=fname, sep="\t", 
    	    append=TRUE , row.names=FALSE, col.names=FALSE)
    write.table(matrix(c("time", "area"), ncol=2), quote = FALSE, 
    	    file=fname, sep="\t", 
    	    append=TRUE , row.names=FALSE, col.names=FALSE)
    write.table(raw_table, file=fname, sep="\t", 
    	    append=TRUE , row.names=FALSE, col.names=FALSE)
}

# too slow
#aligned_peak_data <- align_chromatograms(data = "peak_data_saliva_ccp.txt", rt_col_name="time", 
#					 max_diff_peak2mean = 0.02,
#                                         min_diff_peak2peak = 0.08,
#					 max_linear_shift = 0.05,
#					 delete_single_peak = TRUE) 

