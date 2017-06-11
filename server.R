
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(plyr)
library(shiny)
library(plotly)

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

RGBtoXYZ <- function(rgbFrame) {
  
  conversionMatrix = c(.4497, .3162, .1845, 
                       .2447, .6720, .0833, 
                       .0252, .1412, .9225) %>%
    matrix(3, 3, byrow = T) 
  
  xyzMatrix <- conversionMatrix %*% matrix(c(rgbFrame$r, 
                                             rgbFrame$g, 
                                             rgbFrame$b), 
                                           3, 1)
  
  xyzFrame <- data.frame(rgbFrame,
                         x = xyzMatrix[1], 
                         y = xyzMatrix[2], 
                         z = xyzMatrix[3])
  
  return(xyzFrame)
  
}

LMStoBoyntonMacLeod <- function(lmsFrame) {
  
  boyntonMacLeodFrame <- data.frame(lmsFrame,
                                    l_lm = lmsFrame$l / (lmsFrame$l + lmsFrame$m),
                                    m_lm = lmsFrame$m / (lmsFrame$l + lmsFrame$m),
                                    s_lm = lmsFrame$s / (lmsFrame$l + lmsFrame$m))
  return(boyntonMacLeodFrame)
  
}

# Boynton-MacLeod chromaticity coordinates downloaded from cvrl.org
spectrumBML <- read.csv("mb2_1.csv", header = F)
names(spectrumBML) <- c("nm", "l", "m", "s")
spectrumBML <- ddply(spectrumBML, .(nm), LMStoBoyntonMacLeod) %>%
  filter(nm >= 400)

shinyServer(function(input, output) {

  output$RGBcolor <- renderPlot({
    
    par(mai = c(0, 0, 0, 0))
    plot(c(0, 11), c(0,11), asp = 1, 
         xlim = c(5, 6), ylim = c(5, 6), 
         xlab = "", ylab = "", axes = F)
    rect(1, 1, 10, 10, col = paste("#",
                                   sprintf("%02x", input$red),
                                   sprintf("%02x", input$green),
                                   sprintf("%02x", input$blue),
                                   sep = ""))
    
  })
  
  output$boynton_macleod2D <- renderPlotly({
    
    # Calculate coordinates for the selected color
    selectedColor = data.frame(r = input$red / 255,
                               g = input$green / 255,
                               b = input$blue / 255)
    
    cieXYZ <- RGBtoXYZ(selectedColor)
    cieLMS <- XYZtoLMS(cieXYZ)
    bml <- LMStoBoyntonMacLeod(cieLMS)
    
    # Calculate coordinates for the indiviudal RGB components
    # these are the corners of the RGB color space as shown in the 
    # Boynton-MacLeod diagram
    colorSpace = data.frame(n = c(1, 2, 3),
                            r = c(1, 0, 0),
                            g = c(0, 1, 0),
                            b = c(0, 0, 1))
    
    csXYZ <- ddply(colorSpace, .(n), RGBtoXYZ)
    csLMS <- ddply(csXYZ, .(n), XYZtoLMS)
    csBML <- LMStoBoyntonMacLeod(csLMS)
    
    gplot <- ggplot(data = bml, aes(x = l_lm, y = s_lm)) +
      geom_polygon(data = csBML, fill = "red", alpha = .1) +
      geom_point(data = spectrumBML, color = "blue", alpha = .5) +
      geom_point(color = paste("#",
                               sprintf("%02x", input$red),
                               sprintf("%02x", input$green),
                               sprintf("%02x", input$blue),
                               sep = "")) +
      scale_x_continuous("L/(L+M)", limits = c(0, 1)) +
      scale_y_continuous("S/(L+M)", limits = c(0, 1))
    
    ggplotly(gplot)

  })
  
  output$boynton_macleod <- renderPlotly({
    
    # Calculate coordinates of origin, point in space, and the plane that
    # is the fundament of the Boynton-MacLeod diagram
    selectedColor = data.frame(r = input$red / 255,
                               g = input$green / 255,
                               b = input$blue / 255)
    
    cieXYZ <- RGBtoXYZ(selectedColor)
    cieLMS <- XYZtoLMS(cieXYZ)
    
    RG <- cieLMS$l + cieLMS$m
    R <- c(0, cieLMS$l, cieLMS$l / RG)
    G <- c(0, cieLMS$m, cieLMS$m / RG)
    B <- c(0, cieLMS$s, cieLMS$s / RG)
    rgbValues <- data.frame(R, G, B)
    
    L <- c(0, 0, 1, 1)
    M <- c(1, 1, 0, 0)
    S <- c(0, 1, 0, 1)
    
    plot_ly(x = ~L, y = ~M, z = ~S,
            i = c(2, 1),
            j = c(1, 2),
            k = c(0, 3),
            type = "mesh3d", opacity = .1) %>%
      add_trace(x = ~G, y = ~R, z = ~B, type = "scatter3d", opacity = 1,
                marker = list(size = 4),
                line = list(width = 5)) %>%
      add_trace(data = spectrumBML, x = ~m_lm, y = ~l_lm, z = ~s_lm,
                type = "scatter3d",
                line = list(width = 5),
                marker = list(size = 0),
                opacity = 1)


  })

})
