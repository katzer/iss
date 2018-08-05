## Release Notes: _iss_

### 1.4.6 (not yet released)

1. Compatibility with _ski_ v1.4.6
2. Support for deflated transfer encoding.
3. Convert files with LATIN-9 charset encoding to UTF-8.
   ```json
   // $ORBIT_HOME/config/lfv.json
   
   {
      "encodings": {
        "km/cfg/tcp_config": "latin"
      }
   }
   ```
4. Handle every request within its own process.
5. Cache several API endpoint results on client side that wont change frequently.
5. Ensure that _fifa_ does not include ansi colors in its output.
6. Increase MacOSX min SDK version from 10.5 to to 10.11.
7. Shrink size of executable by 10%.
8. Remove 32-bit build targets.

### 1.4.5 (26.06.2018)

#### Tool

1. Great performance improvements by factor 15.
2. API routes have been redesign without having an `/api` prefix.
   ```
   $ iss --routes
   GET /embed/lfv/{planet}
   GET /jobs
   GET /jobs/{job_id}/reports
   GET /jobs/{job_id}/reports/{id}/results
   GET /planets
   GET /planets/{id}
   GET /planets/{id}/logs
   GET /planets/{id}/logs/{path}
   GET /stats
   GET /stats/{type}/count
   GET /stats/{type}/list
   HEAD /ping
   ```
3. New `HEAD /ping` route for better monitoring and `GET /embed` to embed the app.
4. The config settings for the log file viewer has been redesign and extended to the timestamps.
   ```json
   // $ORBIT_HOME/config/lfv.json
   
   {
     "planets": "type=server%location:apac|p27",
     "files": ["km/log/tcp_trace.*","legato/log/th_*[^1-9][^2-9]","km/cfg/tcp_config"],
   
     "timestamps": [
       ["km/log/tcp_trace.*", 0, "Node",       0, 21, "d.m.y H:i:s.u"],
       ["legato/log/th_*",    0, "KM receive", 0, 26, "d.m.Y H:i:s.u"]
     ]
   }
   ```
   - `planets` is a single string that will be used to invoke _fifa_.
   - `files` is an array of path names who follow the syntax of [fnmatch(3)](http://man7.org/linux/man-pages/man3/fnmatch.3.html).
   - `timestamps` specifies which files contains timestamps and where to find them in each line.
5. New `--timeout` flag to adjust the read timeout of a socket.
6. New `--size` flag to adjust the size of the connection pool.
7. Server continues to run when SIGPIPE or SISSYS signal has been received.
8. Log date, time and signal on graceful shut-down.
9. Fixed various memory leaks.
10. Reduced memory footprint.

#### Web

1. Advanced live-search capabilities for the log file viewer  (search, highlight, navigate and count).
2. Adjustable refresh intervals and download sizes for log files.
3. Filter log file entries by date range.
4. Drop-downs display additional infos like file size, last modified timestamp and the plc identifier for tcp traces
5. Page loads about 3 times faster.
6. Update notifier pops-up when an update has been detected.
7. The log file viewer loads 10 kB from the end of each file by default.

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
