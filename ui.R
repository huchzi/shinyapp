
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(plotly)

shinyUI(fluidPage(

  # Application title
  titlePanel("Show RGB colors in a Boynton-MacLeod diagram"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("red", "R:", min = 0, max = 255, value = 0),
      sliderInput("green", "G:", min = 0, max = 255, value = 0),
      sliderInput("blue", "B:", min = 0, max = 255, value = 1),
      h2("Resulting Color"),
      plotOutput("RGBcolor", width = "150px", height = "150px"),
      p("Use the sliders to select a color in the RGB color space. The color will be shown in the box above.")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Boynton-MacLeod diagram", 
                 plotlyOutput("boynton_macleod2D"),
                 h3("Boynton-MacLeod diagram:"),
                 p("The point shows the selected color in the Boynton-MacLeod diagram. The x-axis shows the excitation of the long-wavelength-sensitivie cones (L-cone or \'red cones\') and the y-axis that of the short-wavelength-sensitive cones (S-cone or \'blue cones\'). Both axes are divided by the sum of the excitation of the L- and M-cones. The red triangle shows the colors that can created in the RGB space, and the blue points represent the spectral colors.")
        ),
        tabPanel("LMS color space", 
                 plotlyOutput("boynton_macleod"),
                 h3("Cone color space:"),
                 p("This diagram shows how the Boynton-MacLeod diagram is derived. It represents the cone color space. The gray area is the Boynton-MacLeod diagram, and the green line represents There are three points on the orange line, which show the origin the selected color in the cone color space and the intercept of the line through these points with the plane that is shown in the Bonyton-MacLeod diagram.")
        ),
        tabPanel("Documentation",
                 h3("Purpose:"),
                 p("The purpose of this app is to teach the user about vision science, specifically about the Boynton-MacLeod diagram. The RGB color space is used as a starting point, because it is widely known."),
                 h3("Cones:"),
                 p("Color perception is made possible by the presence of three different types of cone photoreceptors with different spectral sensitivities. Lights that cause the same excitation in the three photoreceptors will be perceived to be of identical color, even if the physical spectral distribution is different. These colors are said to be metameric."),
                 h5("L-cones:"),
                 p("long-wavelength sensitivte cones (also red cones): peak sensitivity around 560nm"),
                 h5("M-cones:"),
                 p("medium-wavelength sensitivte cones (also red cones): peak sensitivity around 530nm"),
                 h5("S-cones:"),
                 p("short-wavelength sensitivte cones (also red cones): peak sensitivity around 420nm"),
                 a(href = "https://en.wikipedia.org/wiki/Cone_cell", "Learn more on wikipedia"),
                 h3("LMS color space:"),
                 p("Colors can be represented in different color spaces with three axes. These axes can represent the intensity of three spectrally different light (i.e. RGB color space), or of three theoretical lights which would only excite one type of photoreceptor (for example M-cones). Each light can be represented by a point in the color space. The origin is the absence of light (i.e. black), and the distance from the origin represents the brightness. "),
                 a(href = "https://en.wikipedia.org/wiki/LMS_color_space", "Learn more on wikipedia"),
                 h3("Boynton-MacLeod diagram:"),
                 p("The Boynton-MacLeod diagram is a plane in the cone color space where all points have the same luminance. The luminance or perceived brightness depends almost exclusively on the input of the L- and M-cones. Therefore, the plane where L + M = 1 is used for the diagram."),
                 h3("Things to try:"),
                 p("1. Find the location of the spot that represents white and compare it with different shades of gray in the 2D and the 3D plot."),
                 p("2. Set two sliders to zero and look how the location in the cone color space and the Boynton-MacLeod diagram change when the third slider is moved. Lights of identical color but different brightness have the same location in the Boynton-MacLeod diagram."),
                 p("3. See where the colors are located when only one slider is set to zero."),
                 p("4. Try to set the RGB rectangle to a spectral color. Where is this possible?"),
                 h3("References:"),
                 a(href = "cvrl.org", "Coordinates of the spectral lights where downloaded here."),
                 br(),
                 a(href = "https://www.ncbi.nlm.nih.gov/pubmed/490231", "Original paper about the Boynton-MacLeod diagram"),
                 br(),
                 a(href = "http://www.babelcolor.com/index_htm_files/A%20comparison%20of%20four%20multimedia%20RGB%20spaces.pdf", "Matrix for converting apple RGB to CIE color space where taken from this paper.")
                 )
      )
    )
  )
))
