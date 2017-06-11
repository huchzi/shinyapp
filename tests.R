spectrumXYZ <- read.csv("cccie64_1.csv", header = F)
names(spectrumXYZ) <- c("nm", "x", "y", "z")

XYZtoLMS <- function(xyzFrame) {
  
  conversionMatrix <- c(.15514, .54312, -.03286,
                        -.15514, .45684, .03286,
                        0, 0, 0.01608) %>%
    matrix(3, 3, byrow = T) 
  
  lmsMatrix <- conversionMatrix %*% matrix(c(xyzFrame$x, 
                                             xyzFrame$y, 
                                             xyzFrame$z), 
                                           3, 1)
  
  lmsFrame <- data.frame(xyzFrame,
                         l = lmsMatrix[1], 
                         m = lmsMatrix[2], 
                         s = lmsMatrix[3])
  
  return(lmsFrame)
}

library(plyr)

ddply(spectrumXYZ, .(nm), XYZtoLMS)

spectrumXYZ <- read.csv("mb2_1.csv", header = F)

spectrumBML <- read.csv("mb2_1.csv", header = F)
names(spectrumBML) <- c("nm", "l", "m", "s")
LMStoBoyntonMacLeod <- function(lmsFrame) {
  
  boyntonMacLeodFrame <- data.frame(lmsFrame,
                                    m_lm = lmsFrame$m / (lmsFrame$l + lmsFrame$m),
                                    s_lm = lmsFrame$s / (lmsFrame$l + lmsFrame$m))
  return(boyntonMacLeodFrame)
  
}
spectrumBML <- ddply(spectrumBML, .(nm), LMStoBoyntonMacLeod)
