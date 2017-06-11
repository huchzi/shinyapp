Course project: Coursera Developing Data Products
========================================================
author: CH
date: 06/11/2017
autosize: true

Purpose
========================================================

The course project was to write a shiny app:

- I wanted to make something that was useful for myself.
- I work in ophthalmology and vision research.
- I have created an app that demonstrates ways to represent colors that are useful for research in color vision.

How the app is used
========================================================

Using the app is simple. Just use the three sliders to select a color in the RGB space. Then use the tabs two select one of two representations:

- Boynton-MacLeod diagram (2D)
- LMS color space (3D)

The third tab gives access to the documentation.

Methods used for creating the app
========================================================

- Shiny
- Plotly
- GGplot
- Plyr and dplyr
- R presenter for creating this presentation

By the way: we need to include some R code!


```r
three <- 1 + 2

print(three)
```

```
[1] 3
```


Who can use the app?
========================================================

I hope that most people who have the prerequisites to follow the coursera data science specialization will be able to get a basic understanding of the app. 

To understand it fully you need some knowledge about visual perception. Use the documentation and the links to learn about it: it is quite fascinating!

Where is the app found?
========================================================

- You can download the source code from github and run the app if you have R, Rstudio and the necessary libraries installed on your PC.
- You can run the app on shinyapps.io:

https://huchzi.shinyapps.io/boyntonmacleoddiagram/
