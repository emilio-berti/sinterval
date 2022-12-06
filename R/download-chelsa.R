#' @title Get Url To Download CHELSA
#'
#' @param x character, variable to download, e.g. "bio12".
#' @param span character, time span to download.
#' 
#' @return character, absolute path of the downloaded file.
#'
#' @details Download CHELSA data using the suggested wget URL.
#'    I set a hard limit of 10 minutes for each download.
#'
#' @examples
#' library(terra)
#' f <- get_data("bio12")
#' r <- rast(f)
get_data <- function(x, span = "1981-2010") {
   OLDTIMEOUT <- getOption("timeout") #need to increase this for large files
   on.exit(options(timeout = OLDTIMEOUT)) #restore on exit
   options(timeout = max(600, getOption("timeout")))  
   spans <- c("1981-2010", "2011-2040", "2041-2070", "2071-2100")
   if (!span %in% spans) {
      stop("Chosen span is not available. Chose one of: ", 
           paste(spans, collapse = ", "))
   }
   url <- paste0(
      "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/",
      span, "/",
      gsub("[0-9]", "", x), "/",
      "CHELSA_", 
      x, 
      "_",
      span, 
      "_V.2.1.tif"
   )
   message(" - Downloading ", x, 
           " for the period ", span, 
           " in ", tempdir())
   request <- download.file(
     url,
     destfile = file.path(tempdir(), paste0(x, "_", span, ".tif")),
     quiet = TRUE
   )
   stopifnot (request == 0)
   return (file.path(tempdir(), paste0(x, "_", span, ".tif")))
}

#' @title Copy Data To Current Working Directory
#'
#' @param f character, absolute path of the downloaded file.
#' @param verbose TRUE/FALSE.
#' 
#' @return NULL.
#'
#' @examples
#' library(terra)
#' f <- get_data("bio12")
#' r <- rast(f)
copy_data_here <- function(f, verbose = TRUE) {
   

}