# Release Notes: _iss_

The API endpoint for _Orbit_.

## 1.5.2

Released at: 30.08.2024

1. Use SSH Agent instead of `$ORBIT_KEY` for authentication.

2. New _groups_ setting to specify virtual logfiles.
   ```json
   // $ORBIT_HOME/config/lfv.json

   {
      "groups": {
         "Kafka": {
            "planets": "type=server%location:apac|p27",
            "files": [
               "data/logs/kafka/server*"
            ]
         }
      }
   }
   ```

3. New `--workers` flag to adjust the max count of parallel threads.

4. New _filters_ setting to specify server-side content filters.
   ```json
   // $ORBIT_HOME/config/lfv.json

   {
      "filters": [
         ["log/tcp_trace.*", 0, true, "KEY1", "KEY2"], // positive case
         ["log/th_*[^1-9]*", 0, false, "KEY1", "KEY2"] // negative case
      ]
   }
   ```

5. New _cache-controls_ setting to customize header value.

6. New `/configs` endpoint to request client settings.

7. Fix _timestamps_ setting was ignored.

8. Compiled binary for OSX build with MacOSX11.3 SDK.

9. Added binary for `arm64-apple-darwin19` target.

10. Renamed `config/lvf.json` to `config/iss.json`.

11. Removed `--size` flag.

12. Upgraded to mruby 3.1.0

[Full Changelog](https://github.com/katzer/iss/compare/1.5.1...1.5.2)

## 1.5.1

Released at: 18.03.2020

<details><summary>Releasenotes</summary>
<p>

1. Singularized folder names.

2. Hot reload of lfv.json when received `SIGUSR1`.

3. Fixed potential memory leaks.

4. Compiled binary for OSX build with MacOS 10.15 SDK.

5. Upgraded to mruby 2.1.0

[Full Changelog](https://github.com/katzer/iss/compare/1.5.0...1.5.1)
</details>

## 1.5.0

Released at: 13.08.2019

<details><summary>Releasenotes</summary>
<p>

1. Added support for `ECDSA` for both key exchange and host key algorithms.

2. Updated `/logs` endpoint to return list in sorted order.

3. Updated `/jobs` endpoint to include run count and most recent timestamp.

4. Changed `/reports` endpoint to return timestamps as integers.

5. Fixed `/logs/{path}` endpoint failed to load files with null lines.

6. Fixed crash during shutdown when received SIGTERM or similar.

7. Fixed memory leak when converting LATIN-9 encoded files.

8. Renamed `--host` flag to `--bind`.

9. Compiled binary for OSX build with MacOSX10.13 SDK (Darwin17).

10. Upgraded to mruby 2.0.1

</p>

[Full Changelog](https://github.com/katzer/iss/compare/1.4.7...1.5.0)
</details>

## 1.4.7

Released at: 02.01.2019

<details><summary>Releasenotes</summary>
<p>

1. Dropped compatibility with orbit v1.4.6 due to breaking changes in _fifa_.

2. Removed LVAR section for non test builds.

3. Upgraded to mruby 2.0.0

</p>

[Full Changelog](https://github.com/katzer/iss/compare/1.4.6...1.4.7)
</details>

## 1.4.6

Released at: 16.08.2018

<details><summary>Releasenotes</summary>
<p>

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

6. New `--cleanup` flag to adjust the interval to cleanup forked processes.

7. Ensure that _fifa_ does not include ansi colors in its output.

8. Increase MacOSX min SDK version from 10.5 to to 10.11.

9. Remove 32-bit build targets.

</p>

[Full Changelog](https://github.com/katzer/iss/compare/1.4.5...1.4.6)
</details>

## 1.4.5

Released at: 26.06.2018

<details><summary>Releasenotes</summary>
<p>

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

</p>

[Full Changelog](https://github.com/katzer/iss/compare/1.4.5...1.4.6)
</details>

## 1.4.4

Released at: 12.02.2018

<details><summary>Releasenotes</summary>
<p>

Initial release

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

</p>

[Full Changelog](https://github.com/katzer/iss/compare/e8a9c6f8e1787757c35c2708800affea78fe656d...1.4.4)
</details>
