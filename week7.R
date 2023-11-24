pacman::p_load(tidyverse, # tidyverse pkgs including purrr
               purrr, # automating
               xml2L, # parsing XML
               rvest, # parsing HTML
               robotstxt, #checking path is permitted
               ggplot)
library(rvest)
library(xml2)
#see whether path is allowed to be scraped
paths_allowed(paths="https://finance.yahoo.com/world-indices")
parsed <- read_html("https://finance.yahoo.com/world-indices")
parsed_sub <- html_element(parsed, xpath = '//*[@id="list-res-table"]/div[1]/table')


table.df <-html_table(parsed_sub)   
head(table.df)
view(table.df)
yahoo_data <- table.df %>%
  select("Name", "Last Price", "% Change") 
yahoo_data
rm(yahoo_data)


install.packages("plotly")
library(plotly)
yahoo_data$`% Change` <- as.numeric(sub("%", "", yahoo_data$`% Change`))

color_vector <- scales::col_numeric(palette = "viridis", domain = yahoo_data$`% Change`)(yahoo_data$`% Change`)

plot_ly(yahoo_data, x = ~Name, y = ~`Last Price`, type = "bar", text = ~paste(`Last Price`), 
        marker = list(color = color_vector)) %>%
  layout(title = "World Indices", xaxis = list(title = "Index"), yaxis = list(title = "Last Price"))














#Method-1 scrape the whole table from the web and select specific rows from the table then visualize
pacman::p_load(tidyverse, # tidyverse pkgs including purrr
               purrr, # automating 
               xml2L, # parsing XML
               rvest, # parsing HTML
               robotstxt) #checking path is permitted 

#See whether scrappable
paths_allowed(paths = "https://finance.yahoo.com/world-indices/?guccounter=1")


library(rvest)
library(xml2)
url <- "https://finance.yahoo.com/world-indices/?guccounter=1"
parsed <- read_html(url) #read the whole information

#scrap the table of the information
parsed.sub <- html_element(parsed, xpath = '//*[@id="mrt-node-Lead-4-YFinListTable"]')

#covert the html texts into table
table.df <- html_table(parsed.sub)   
head(table.df)

#select three columns from the table
yahoo_data <- table.df %>%
  select(Name, `Last Price`, `% Change`)
yahoo_data

install.packages("plotly")
library(plotly)

#change the percentage into numeric information
yahoo_data$`% Change` <- as.numeric(sub("%", "", yahoo_data$`% Change`))

#use col_numeric from scales to set the color of the bar by extracting the data from %change
color_vector <- scales::col_numeric(palette = "viridis", domain = yahoo_data$`% Change`)(yahoo_data$`% Change`)

#plot the bar chart by defining x and y value
plot_ly(yahoo_data, x = ~Name, y = ~`Last Price`, type = "bar", text = ~paste(`Last Price`) #Sets the text displayed when hovering over each bar., 
        marker = list(color = color_vector)) #Attempts to set the color of each bar based on the color_vector.
%>%
  layout(title = "World Indices", xaxis = list(title = "Index"), yaxis = list(title = "Last Price"))



