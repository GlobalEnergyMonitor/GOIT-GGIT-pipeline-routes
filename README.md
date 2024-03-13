# GOIT-GGIT-pipeline-routes
This is a GitHub repository at Global Energy Monitor to store pipeline routes.

Individual routes are stored as `[ProjectID].geojson`, in the `data > individual-files` folder.

## Every project has a GeoJSON file associated with it.
If a given project does not have a route, either because it's a capacity expansion with no actual new pipeline associated with it, or because we haven't created the route yet or cannot find a map to trace online, we STILL create a `.geojson` file for it, it's just stored as an **empty GeoJSON file** (i.e., `None`-type geometry).
