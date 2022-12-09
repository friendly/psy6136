library(htmltools)
# table tags
tab <- function (...)
  tags$table(...)

td <- function (...) 
  tags$td(...)
tr <- function (...) 
  tags$tr(...)

# an <a> tag with href as the text to be displayed
aself <- function (href, ...)
  a(href, href=href, ...)

# thumnail figure with href in a table column / row
tabfig <- function(name, img, href, ...) {
  td(
    a(class = "thumbnail", title = name, href = href,
      img(src = img, ...)
    )
  )
}
tabtxt <- function(text, ...) {
  td(text, ...)
}
