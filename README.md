# iss [![GitHub release](https://img.shields.io/github/release/appPlant/iss.svg)](https://github.com/appPlant/iss/releases) [![Build Status](https://travis-ci.com/appPlant/iss.svg?branch=master)](https://travis-ci.com/appPlant/iss) [![Build status](https://ci.appveyor.com/api/projects/status/ihdgs8rtuexwtiv7/branch/master?svg=true)](https://ci.appveyor.com/project/katzer/iss/branch/master) [![codebeat badge](https://codebeat.co/badges/e8186575-89a2-4bb3-867f-257069891488)](https://codebeat.co/projects/github-com-appplant-iss-master)

A web frontend and API endpoint for _Orbit_.

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

You'll need to add `ORBIT_HOME` first to your profile:

    $ export ORBIT_HOME=/path/to/orbit

## Installation

Download the latest version from the [release page][releases] and add the executable to your `PATH`.

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

The tool expects to find the index.html file and related ressources under `$ORBIT_HOME/public/iss`. The file `$ORBIT_HOME/public/iss/index.html` maps to `localhost:1974/iss/index.html`.

All static assets placed under the document root will become available. Please don't put sensitive data there!

## Development

Clone the repo:
    
    $ git clone https://github.com/appplant/iss.git && cd iss/

Install the dependencies:

    $ bundle

And then execute:

    $ rake compile

To compile the sources locally for the host machine only:

    $ MRUBY_CLI_LOCAL=1 rake compile

You'll be able to find the binaries in the following directories:

- Linux (64-bit Musl): `build/x86_64-alpine-linux-musl/bin/iss`
- Linux (64-bit GNU): `build/x86_64-pc-linux-gnu/bin/iss`
- Linux (64-bit, for old distros): `build/x86_64-pc-linux-gnu-glibc-2.12/bin/iss`
- OS X (64-bit): `build/x86_64-apple-darwin17/bin/iss`
- Windows (64-bit): `build/x86_64-w64-mingw32/bin/iss`
- Host: `build/host2/bin/iss`

For the complete list of build tasks:

    $ rake -T

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/appplant/iss.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The code is available as open source under the terms of the [Apache 2.0 License][license].

Made with :heart: in Leipzig

© 2016 [appPlant GmbH][appplant]

[releases]: https://github.com/appplant/iss/releases
[license]: http://opensource.org/licenses/Apache-2.0
[appplant]: www.appplant.de
