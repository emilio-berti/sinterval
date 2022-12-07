import pandas as pd
import geopandas as geopd
import matplotlib.pyplot as plt

d = []
with open("ghcn-metadata.csv", "r") as file:
   f = file.readlines()
   for l in f:
      row = []
      l = l.strip()
      l = l.split(" ")
      valid = [len(x) > 0 for x in l]
      if sum(valid) == 0:
         next()
   
      l.pop(0)
      valid = [len(x) > 0 for x in l]
      for i in range(sum(valid)):
         try:
            float(l[valid.index(True)])
         except:
            l.pop(valid.index(True))
            valid.pop(valid.index(True))
         else:
            row.append(float(l[valid.index(True)]))
            l.pop(valid.index(True))
            valid.pop(valid.index(True))
   
      d.append(row)

d = pd.DataFrame(d, columns = ['y', 'x', 'elev', 'na'])
geometry = geopd.points_from_xy(d['x'], d['y'], d['elev'])
gdf = geopd.GeoDataFrame(d, geometry = geometry)
gdf = gdf[gdf['y'] < 90]
gdf = gdf[gdf['elev'] >= 0]

fig, ax = plt.subplots(1, 1)
gdf.plot(column = 'elev', ax = ax, markersize = 2, cmap = 'RdBu')
plt.show()

gdf.to_file('ghcn.shp')

plt.hist(gdf['elev'])
plt.show()