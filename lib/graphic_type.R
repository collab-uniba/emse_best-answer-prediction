# Returns the appropriate graphic type depending on the current OS
get_graphic_type <- function() {
  type = ""
  if(.Platform$OS.type == "windows") {
    type = "windows"
  } else {
    type = "quartz"
  }
  return(type)
}