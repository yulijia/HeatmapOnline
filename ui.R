library(shiny)
 
shinyUI(fluidPage(
  titlePanel(" "),
  sidebarLayout(
    sidebarPanel(
      includeCSS('bootstrap.min.css'),
      includeHTML('header.html'),
      
      fileInput('file1', 'Choose file to upload',
                accept = c(
                  'text/csv',
                  'text/comma-separated-values',
                  'text/tab-separated-values',
                  'text/plain',
                  '.csv',
                  '.tsv'
                )
      ),
      tags$hr(),
      checkboxInput('header', 'Header', TRUE),
      radioButtons('sep', 'Separator',
                   c(Comma=',',
                     Semicolon=';',
                     Tab='\t'),
                   ','),
      radioButtons('quote', 'Quote',
                   c(None='',
                     'Double Quote'='"',
                     'Single Quote'="'"),
                   '"'),
      tags$hr(),
      p('If you want a sample .csv or .tsv file to upload,',
        'you can first download the sample',
        a(href = 'mtcars.csv', 'mtcars.csv'), 'or',
        a(href = 'pressure.tsv', 'pressure.tsv'),
        'files, and then try uploading them.'
      ),
      sliderInput(inputId = "height",
                  label = "Picture height",                            
                  min = 10, max = 100, step = 1, value = 20),
      sliderInput(inputId = "width",
                  label = "Picture width",                            
                  min = 10, max = 100, step = 1, value = 20),
      downloadButton('downloadPlot', 'Download Plot')
      
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Heatmap Plot", plotOutput('distPlot')),
        tabPanel("Data Table",tableOutput('contents')),
        tabPanel("Cite this app",
                 includeHTML('cite.html')
        )
      ),
      includeHTML('footer.html')
    )
  )
)

)

