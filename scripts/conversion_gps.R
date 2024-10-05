#Fonction qui converti les coordonées GPS en lat et long
convert_coordinates <- function(deg, min, sec, dir) {
  decimal <- as.numeric(deg) + as.numeric(min) / 60 + as.numeric(sec) / 3600
  
  if (any(grepl("S|W", dir, fixed = TRUE))) {
    decimal <- -decimal
  }
  
  return(decimal)
}