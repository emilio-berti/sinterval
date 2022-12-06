source("R/download-chelsa.R")

dem <- rast("DEM-island.tif")

# CHELSA ----------
f <- get_data("bio17")
r <- rast(f)
r <- project(r, dem)
r <- mask(r, dem)
writeRaster(r, "chelsa_bio17.tif")

# WorldClim --------------
r <- raster::getData(
   name = "worldclim",
   var = "bio",
   res = .5, 
   lon = -27, 
   lat  = 39
)
r <- r$bio17_15
writeRaster(r, "worldclim_bio17.tif")
