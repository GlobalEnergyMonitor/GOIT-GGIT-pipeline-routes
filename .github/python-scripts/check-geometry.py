# this script will try to open a geojson file
# if it's successful it means the file doesn't seem to have any errors and can likely be merged into main

import geopandas
import sys

print(sys.argv[1])

def open_file(file=None):
    if len(sys.argv)>1:
        file=sys.argv[1]
    else:
        print('You must specify a filename using the full path, e.g., "../../file.geojson"')
        return
    #print('opening file')
    file_gdf = geopandas.read_file(file)
    print(file_gdf.geometry)

if __name__ == '__main__':
    open_file(file=None)
