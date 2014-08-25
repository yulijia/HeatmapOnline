library(shiny)
library(latticeExtra)
library(reshape)
library(lattice)

data(mtcars)

options(shiny.maxRequestSize = 9*1024^2)

shinyServer(function(input, output) {
  
  output$contents <- renderTable({
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    
    inFile <- input$file1
    
    if (is.null(inFile))
      return(mtcars)
    
    read.csv(inFile$datapath, header = input$header,
             sep = input$sep, quote = input$quote)
  })
  datasetInput <- reactive({
    
    inFile <- input$file1
    
    if (is.null(inFile)){
      return(mtcars)
    }else{
      df <- read.table(inFile$datapath, header = input$header,
                       sep = input$sep, quote = input$quote)
      
      return(df)
    }
  })
  
  heightSize <- function(){
    input$height*50
  }
  widthSize <- function(){
    input$width*50
  }
  
  heatplot <- function(){
    x <- scale((datasetInput()))
    dd.row <- as.dendrogram(hclust(dist(x)))
    row.ord <- order.dendrogram(dd.row)
    dd.col <- as.dendrogram(hclust(dist(t(x))))
    col.ord <- order.dendrogram(dd.col)
    p1 <- levelplot(
      x[row.ord, col.ord],
      aspect = "fill",
      scales = list(x = list(rot = 90,cex=0.8*input$width/10),y=list(cex=1*input$height/10)),
      colorkey = list(space = "left", labels = list(cex=1*input$width/10)),
      xlab=list(cex=1*input$width/10),
      ylab=list(cex=1*input$height/10),
      legend = list(right = list(fun = dendrogramGrob,
                                 args = list(x = dd.col,ord = col.ord,side = "right",size = 10*input$width/10)),
                    top = list(fun = dendrogramGrob,
                               args = list(x = dd.row,side = "top",size = 10*input$height/10))
      )
    )
    plot(p1)
  }
  
  
  output$distPlot <- renderPlot({
    heatplot()
  },width=widthSize,height=heightSize)
  
  output$downloadPlot <- downloadHandler(
    filename = 'myplots.png',
    content = function(file) {
      png(file, width = input$width*50, height = input$height*50, units = "px", pointsize = 12, bg = "white", res = NA)
      heatplot()
      dev.off()
    },
    contentType = 'image/png'
  )
})