## Release Notes: _iss_

### 1.4.5 (not yet released)

- [web] Render only the visible part of the log file to improve preformance.
- [web] Support for regex in the log file filter.
- [web] Show AKZ for tcp_trace files in LFV module.
- [web] Faster page loading.
- [web] Dialog pops up to request a reload when a new version is available.
- [iss] Map PLC identifier with tcp_trace files via tcp_config.
- [iss] Fix 404 return code even the URL exist due to a memory leak.
- [iss] Fix potential endless loop when client opens a socket connection but does not send anything resulting in a frozen behaivor and slow load time of the web app.
- [iss] New -t flag to customize the recv timeout.

### 1.4.4 - Initial release (12.02.2018)

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
