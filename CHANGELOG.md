## Release Notes: _iss_

### 1.4.4 - Initial release (not yet released)

A web frontend and API endpoint for _Orbit_.

```
$ usage: iss [options...]
Options:
-e, --environment The environment to run the server with
-h, --host        The host to bind the local server on
                  Defaults to: 0.0.0.0
-p, --port        The port number to start the local server on
                  Defaults to: 1974
-r, --routes      Print out all defined routes
-h, --help        This help text
-v, --version     Show version number
```

All endpoints have the `/api/` prefix and usually return a JSON encoded result set.

```
$ iss --routes
GET /api/stats
GET /api/stats/{type}/count
GET /api/stats/{type}/list
GET /api/jobs
GET /api/jobs/{job_id}/reports
GET /api/jobs/{job_id}/reports/{id}/results
GET /api/lfv/planets
GET /api/lfv/planets/{id}/files
GET /api/lfv/planets/{id}/file
```

For example to get the total number of planets with type of _web_:

```
$ curl localhost:1974/api/stats/web/count
```

The tool expects to find the index.html file and related ressources under `$ORBIT_HOME/public/iss`. The file `$ORBIT_HOME/public/iss/index.html` maps to `localhost:1974/iss/index.html`.
