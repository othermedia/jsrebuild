jsrebuild
=========

**jsrebuild** dynamically runs the [Jake] build tool to rebuild JavaScript
projects in development environments.

[Jake]: https://github.com/jcoglan/jake

Overview
--------

Jake is often run as part of a website's build process, building JavaScript
packages from source files. This often leads to a tedious situation for
projects which use Jake, as the developer must continually run the `jake`
command to rebuild their JavaScript files as they make changes to the source
code.

The `jsrebuild` utility provides a solution to this problem: it watches a
source directory and rebuilds the project whenever changes are made to the
source files, `jake.yml` config file and the `Jakefile` helper file.


Installation
------------

jsrebuild uses the [Cool.io] library which depends on [libev], a low-level
event loop library, so you will need to have libev installed before attempting
to install the jsrebuild gem.

jsrebuild is available from RubyGems, so you can install it and its
dependencies simply by running

    gem install jsrebuild

[cool.io]: https://github.com/tarcieri/cool.io
[libev]: http://software.schmorp.de/pkg/libev.html


Running `jsrebuild`
-------------------

To watch a particular directory such as `~/projects/mywebapp` for changes, just
run

    jsrebuild ~/projects/mywebapp

The `jsrebuild` tool takes a number of command-line arguments, allowing you to
set options such as the interval at which it checks files for changes, and
whether or not to force all the project's packages to be rebuild whenever a
change is made.

For a full list of options, run `jsrebuild --help`.

`jsrebuild` will happily run daemonised. To shut down the process, simply send
it `SIGHUP` and it will shut down the event loop and exit cleanly.
