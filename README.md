# GOIT-GGIT-pipeline-routes
This is a GitHub repository at Global Energy Monitor to store pipeline routes.

Individual routes are stored as `[ProjectID].geojson`, in the `data > individual-files` folder.

## Every project has a GeoJSON file associated with it.
If a given project does not have a route, either because it's a capacity expansion with no actual new pipeline associated with it, or because we haven't created the route yet or cannot find a map to trace online, we STILL create a `.geojson` file for it, it's just stored as an **empty GeoJSON file** (i.e., `None`-type geometry).

An example of an "empty" GeoJSON file could look something like this:
```
{
"type": "FeatureCollection",
"crs": { "type": "name", "properties": { "name": "urn:ogc:def:crs:OGC:1.3:CRS84" } },
"features": [
{ "type": "Feature", "properties": { "ProjectID": "P6445" }, "geometry": null }
]
}
```
or like this:
```
{"type":"FeatureCollection","features":[{"type":"Feature","geometry":null}]}
```

## Contribute by creating a new branch and a pull request

If you update a route or multiple routes...
1. Create a _new_ branch with a short, informative title (for example, `firstname-p9998-p9999`)
2. Add your changes to the branch and push it to the repository
3. Create a pull request and assign it to Baird for review

## How can I create a GeoJSON file from scratch for a route?

* If you are comfortable working in [QGIS](https://www.qgis.org/en/site/) or [JOSM](https://josm.openstreetmap.de/), those are the most complex ways to do it. Create a route or edit an existing one and re-export it as a GeoJSON file. You __don't__ need to include any specific information about the pipeline itself (name, status, etc.) in the GeoJSON file; the __only__ way I ask you to label it is via the title: `[ProjectID].geojson`. (You can of course include more info, but it's not necessary.)

* If you're creating a new route from scratch, and the tools above aren't familiar, try using [geojson.io](https://geojson.io/) or [placemark.io](https://play.placemark.io/).

* If you're editing an existing route, you can import the GeoJSON file that already exists for it

## Coordinate reference system

The [GeoJSON](https://geojson.org/) file format specification says that GeoJSON files use a WSG 84 (EPSG:4326) coordinate reference system, so this is expected for all pipelines and no crs is required in the GeoJSON file.
