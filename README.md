# iss [![GitHub release](https://img.shields.io/github/release/appPlant/iss.svg)](https://github.com/appPlant/iss/releases) [![Build Status](https://travis-ci.org/appPlant/iss.svg?branch=master)](https://travis-ci.org/appPlant/iss) [![Build status](https://ci.appveyor.com/api/projects/status/ihdgs8rtuexwtiv7/branch/master?svg=true)](https://ci.appveyor.com/project/katzer/iss/branch/master) [![codebeat badge](https://codebeat.co/badges/e8186575-89a2-4bb3-867f-257069891488)](https://codebeat.co/projects/github-com-appplant-iss-master)

Web frontend and API endpoint for _Orbit_.

    $ usage: iss [options...]
    Options:
    -e, --environment The environment to run the server with.
    -h, --host        The host to bind the local server on.
                      Defaults to: 0.0.0.0
    -p, --port        The port number to start the local server on.
                      Defaults to: 1974
    -h, --help        This help text
    -v, --version     Show version number


## Prerequisites

You'll need to add your `ORBIT_HOME` and `ORBIT_FILE` first to your profile:

    $ export ORBIT_HOME=/path/to/orbit
    $ export ORBIT_FILE=/path/to/orbit/config/orbit.json


## Installation

Download the latest version from the [release page][releases] and add the executable to your `PATH`.


## Basic Usage

TODO


## Development

Clone the repo:
    
    $ git clone https://github.com/appPlant/iss.git && cd iss/

Make the scripts executable

    $ chmod u+x scripts/*

And then execute:

    $ scripts/compile

To compile the sources locally for the host machine only:

    $ MRUBY_CLI_LOCAL=1 rake compile

You'll be able to find the binaries in the following directories:

- Linux (64-bit BusyBox): `mruby/build/x86_64-pc-linux-busybox/bin/iss`
- Linux (64-bit GNU): `mruby/build/x86_64-pc-linux-gnu/bin/iss`
- Linux (64-bit, for old distros): `mruby/build/x86_64-pc-linux-gnu-glibc-2.12/bin/iss`
- Linux (32-bit GNU): `mruby/build/i686-pc-linux-gnu/bin/iss`
- Linux (32-bit, for old distros): `mruby/build/i686-pc-linux-gnu-glibc-2.12/bin/iss`
- OS X (64-bit): `mruby/build/x86_64-apple-darwin15/bin/iss`
- OS X (32-bit): `mruby/build/i386-apple-darwin15/bin/iss`
- Windows (64-bit): `mruby/build/x86_64-w64-mingw32/bin/iss`
- Windows (32-bit): `mruby/build/i686-w64-mingw32/bin/iss`
- Host: `mruby/build/host2/bin/iss`


## Releases

    $ scripts/release

After this command finishes, you'll see the /releases for each target in the releases directory.


## Tests

To run all tests:

    $ scripts/test


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/appplant/iss.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## License

The code is available as open source under the terms of the [Apache 2.0 License][license].

Made with :yum: from Leipzig

© 2016 [appPlant GmbH][appplant]

[releases]: https://github.com/appPlant/iss/releases
[docker]: https://docs.docker.com/engine/installation
[license]: http://opensource.org/licenses/Apache-2.0
[appplant]: www.appplant.de
