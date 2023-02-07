# create a <div> ... </div> heading with an icon

# Generate HTML like this:
  # <div style="display:flex">
  #   <i class="fas fa-list" style="color:darkgreen; font-size: 1.25em;"></i> &nbsp;
  #   <h4>Topics</h4>
  # </div>
  #     
  # <div style="display:flex">
  #   <i class="fas fa-file-pdf" style="color:red; font-size: 1.25em;"></i> &nbsp;
  #   <h4>Lecture notes</h4>
  # </div>
    

#' create a <div> ... </div> heading with an icon
#'
#' @param type   Type of heading
#' @param level  HTML level of heading
#' @param icon_size Relative size of the icon
#'
#' @return a text string
#' @export
#'
#' @examples
div_heading <- function(
  type = c("topics", "lecture", "readings", "assign", "quiz"),
  level = 4,
  icon_size = "1.2em"
  )
{
  type = match.arg(type)

  info <- tibble::tibble(
    type =  c("topics", "lecture", "readings", "assign", "quiz"),
    title = c("Topics", "Lecture notes", "Readings", "Assignment", "Quiz"),
    icon =  c("fas fa-list", "fas fa-file-pdf", "fas fa-book-reader", "fas fa-building", "fas fa-question"),
    color = c("darkgreen", "red", "blue", "brown", "purple")
  )
  
  item <- which(info$type == type)
  title <- info[item, "title"]
  icon <- info[item, "icon"]
  color <- info[item, "color"]

  text <- glue::glue('
<div style="display:flex">
  <i class="{icon}" style="color:{color}; font-size: {icon_size};"></i> &nbsp;
  <h{level}>{title}</h{level}>
</div>

')

  cat(text)             

}

# test
TEST <- FALSE
if(TEST) {
div_heading("topics")

div_heading("lecture")

div_heading("readings")

}
