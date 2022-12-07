library(terra)

cielo <- rast("~/Documents/cielo/Terceira_Raw/Normal_Observado/bio17.tif")
dem <- rast("DEM-island.tif")
dem <- project(dem, cielo)
wc <- rast("worldclim_bio17.tif")
wc <- project(wc, cielo)
chelsa <- rast("chelsa_bio17.tif")
chelsa <- project(chelsa, cielo)

r <- c(dem, cielo, wc, chelsa)
names(r) <- c("DEM", "CIELO", "WorldClim", "CHELSA")
r <- mask(r, cielo)

pdf("bio17-comparison.pdf", width = 12, height = 8)
par(mfrow = c(2, 2))
plot(r[[2]], main = "CIELO", col = viridis::viridis(100))
contour(r[[1]], add = TRUE, nlevels = 7, col = "grey90")
plot(r[[3]], main = "WorldClim", col = viridis::viridis(100))
contour(r[[1]], add = TRUE, nlevels = 7, col = "grey90")
plot(r[[4]], main = "CHELSA", col = viridis::viridis(100))
contour(r[[1]], add = TRUE, nlevels = 7, col = "grey90")
dev.off()

# scatter plot -------
library(tidyverse)

vals <- r |> 
   values() |> 
   as_tibble() |> 
   drop_na()

vals |> 
   pivot_longer(cols = WorldClim:CHELSA,
                names_to = "database") |> 
   ggplot() +
   aes(CIELO, value, col = database) +
   geom_point(alpha = .05, shape = 20) +
   geom_smooth(aes(groups = database), col = "grey20") +
   scale_color_manual(values = c("darkred", "dodgerblue3")) +
   ylab("Precipitation of driest quarter") +
   theme_bw()

ggsave("scatterplot.png", width = 4, height = 3, dpi = 600)

wc <- with(vals, lm(CIELO ~ WorldClim))
chelsa <- with(vals, lm(CIELO ~ CHELSA))

summary(wc)$adj.r.squared
summary(chelsa)$adj.r.squared

vals |> 
   ggplot() +
   aes(CHELSA, WorldClim, col = DEM) +
   geom_point() +
   geom_smooth(col = "grey20") +
   scale_color_gradient2(low = "green4", high = "grey90",
                         midpoint = 500, mid = "orange") +
   theme_bw()

m <- with(vals, lm(WorldClim ~ CHELSA))
summary(m)$adj.r.squared
