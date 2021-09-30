#options(browser = 'google-chrome') 
if(!require(pacman))install.packages("pacman")
pacman::p_load("MALDIquant", "plotly")

loadData <- function(drs) {
    spectra <- list()
    j <- 0

    for(dr in drs) {
        fls <- dir(dr)
        fls <- fls[grep(".csv", fls)]
        for(i in 1:length(fls)){
            j <- j+1
            raw <- read.csv(paste0(dr, fls[i]), check.names=FALSE)
            spectra[[j]] <- createMassSpectrum(mass=raw[,2], intensity=raw[,4],
                                               metaData=list(name=sub('.csv', '', fls[i])))
        }
    }
    return(spectra)
}

featMat <- function(spectra, type='feat') {
    spectra <- transformIntensity(spectra, method="sqrt") 
    spectra <- smoothIntensity(spectra, method="MovingAverage") 
    spectra <- removeBaseline(spectra) 
    spectra <- alignSpectra(spectra) 
    if(type=='aln'){
        return(spectra)
    }
    peaks <- detectPeaks(spectra, method="MAD", 
                         halfWindowSize=20, SNR=2)
    if(type=='peaks'){
        return(peaks)
    }
    peaks <- binPeaks(peaks, tolerance=0.002) 
    peaks <- filterPeaks(peaks, minFrequency=0.25) 
    featureMatrix <- intensityMatrix(peaks, spectra) 
    if(type=='feat'){
        rownames(featureMatrix) <- unlist(lapply(spectra, function(x) x@metaData$name)) 
        return(featureMatrix)
    }
}

getIdx <- function(spectra, name) {
    idx <- which(lapply(spectra, function(x) x@metaData$name==name)==TRUE) 
    return(idx)
}

plotBaseline <- function(spectrum) { 
    baseline <- estimateBaseline(spectrum)
    plot(spectrum) 
    lines(baseline, col="red", lwd=2) 
}

plotPeaks <- function(spectrum, peaks) {
    plot(spectrum)
    points(peaks, col="red", pch=4) 
}

plotlyBaseline <- function(spectrum) { 
    baseline <- estimateBaseline(spectrum)

    fig <- plot_ly(x = spectrum@mass, y = spectrum@intensity, 
                  name = spectrum@metaData$name, type = 'scatter', 
                  mode = 'lines') 
    fig <- fig %>% add_trace(x = baseline[,1], y = baseline[,2], name = 'baseline', mode = 'lines') 
    #fig <- fig %>% add_trace(y = ~trace_2, name = 'trace 2', mode = 'markers')

    return(fig)
}

plotlyPeaks <- function(spectrum, peaks) {
    fig <- plot_ly(x = spectrum@mass, y = spectrum@intensity, 
                  name = spectrum@metaData$name, type = 'scatter', 
                  mode = 'lines') 
    fig <- fig %>% add_trace(x = peaks@mass, y = peaks@intensity, name = 'peaks', mode = 'markers') 

    return(fig)

}

plotly3d <- function(spectra) {
    RT <- c()
    Intensity <- c()
    Samples <- c()
    for(s in spectra){
        RT <- c(RT, s@mass)
        Intensity <- c(Intensity, s@intensity)
        Samples <- c(Samples, rep(s@metaData$name, length(s@intensity)))
    }
    data <- data.frame(
      RT = RT,
      Intensity = Intensity,
      Samples = Samples)
    
    fig <- plot_ly(data, x = ~RT, y = ~Intensity, z = ~Samples, type = 'scatter3d', 
                   mode = 'lines', color = ~Samples)
    
    return(fig)
}
