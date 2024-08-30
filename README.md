# iss - The API endpoint for _Orbit_ <br> [![GitHub release](https://img.shields.io/github/release/katzer/iss.svg)](https://github.com/katzer/iss/releases) [![Build Status](https://travis-ci.com/katzer/iss.svg?branch=master)](https://travis-ci.com/katzer/iss) [![Build status](https://ci.appveyor.com/api/projects/status/ihdgs8rtuexwtiv7/branch/master?svg=true)](https://ci.appveyor.com/project/katzer/iss/branch/master) [![Maintainability](https://api.codeclimate.com/v1/badges/5b6eefc8260ef6d6dd0f/maintainability)](https://codeclimate.com/github/katzer/iss/maintainability)

    $ iss -h
    
    Usage: iss [options...]
    Options:
    -b, --bind        The host to bind the local server on
                      Defaults to: 0.0.0.0
    -c, --cleanup     Interval to cleanup forked processes
                      Defaults to: 5 (sec)
    -e, --environment The environment to run the server with
    -p, --port        The port number to start the local server on
                      Defaults to: 1974
    -r, --routes      Print out all defined routes
    -s, --size        Max pool size for SFTP/SSH sessions
                      Defaults to: 5
    -t, --timeout     Receive timeout before socket will be closed
                      Defaults to: 1 (sec)
    -h, --help        This help text
    -v, --version     Show version number

## Prerequisites

You'll need to add `ORBIT_HOME` and `ORBIT_BIN` first to your profile:

    $ export ORBIT_HOME=/path/to/orbit

Then setup the SSH agent for passwordless authentication:

    $ ssh-add /path/to/key

## Installation

Download the latest version from the [release page][releases] and add the executable to your `PATH`.

## Configuration

The tool expects to find the __lfv.json__ file at `$ORBIT_HOME/config/lfv.json`.

```json
{
  "planets": "type=server%location:apac|p27",

  "files": [
    "log/tcp_trace.*",
    "log/th_*[^1-9][^2-9]"
  ],

  "encodings": {
    "log/th_*": "latin"
  },

  "timestamps": [
    ["log/tcp_trace.*", 0, "Node",       0, 21, "d.m.y H:i:s.u"],
    ["log/th_*",        0, "KM receive", 0, 26, "d.m.Y H:i:s.u"]
  ],

  "filters": [
    ["log/tcp_trace.*", 0, "TRACE", "INFO"]
  ]
}
```

To reload the config at runtime:

    $ kill -s USR1 pid

## API

All endpoints return a JSON encoded result set.

    $ iss --routes
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

For example to get the total number of planets with type of _web_:

    $ curl localhost:1974/stats/web/count

## Web App

The tool expects to find the __index.html__ file and related ressources under `$ORBIT_HOME/public/iss`. The file `$ORBIT_HOME/public/iss/index.html` maps to `localhost:1974/iss/index.html`.

All static assets placed under the document root will become available. Don't put sensitive data there!

## Development

Clone the repo:
    
    $ git clone https://github.com/katzer/iss.git && cd iss/

Install the dependencies:

    $ bundle

And then execute:

    $ rake compile

To compile the sources locally for the host machine only:

    $ MRUBY_CLI_LOCAL=1 rake compile

You'll be able to find the binaries in the following directories:

- Linux (AMD64, Musl): `build/x86_64-alpine-linux-musl/bin/iss`
- Linux (AMD64, GNU): `build/x86_64-pc-linux-gnu/bin/iss`
- Linux (AMD64, for old distros): `build/x86_64-pc-linux-gnu-glibc-2.9/bin/iss`
- OS X (AMD64): `build/x86_64-apple-darwin19/bin/iss`
- OS X (ARM64): `build/arm64-apple-darwin19/bin/iss`
- Windows (AMD64): `build/x86_64-w64-mingw32/bin/iss`
- Host: `build/host/bin/iss`

For the complete list of build tasks:

    $ rake -T

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/katzer/iss.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The code is available as open source under the terms of the [Apache 2.0 License][license].

Made with :heart: in Leipzig

© 2016 [appPlant GmbH][appplant]

[releases]: https://github.com/katzer/iss/releases
[license]: http://opensource.org/licenses/Apache-2.0
[appplant]: www.appplant.de
