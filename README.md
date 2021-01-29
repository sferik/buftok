# BufferedTokenizer

[![Gem Version](http://img.shields.io/gem/v/buftok.svg)][gem]
[![Build Status](http://img.shields.io/travis/sferik/buftok.svg)][travis]
[![Dependency Status](http://img.shields.io/gemnasium/sferik/buftok.svg)][gemnasium]
[![Code Climate](http://img.shields.io/codeclimate/github/sferik/buftok.svg)][codeclimate]

[gem]: https://rubygems.org/gems/buftok
[travis]: https://travis-ci.org/sferik/buftok
[gemnasium]: https://gemnasium.com/sferik/buftok
[codeclimate]: https://codeclimate.com/github/sferik/buftok

###### Statefully split input data by a specifiable token

BufferedTokenizer takes a delimiter upon instantiation, or acts line-based by
default.  It allows input to be spoon-fed from some outside source which
receives arbitrary length datagrams which may-or-may-not contain the token by
which entities are delimited.  In this respect it's ideally paired with
something like [EventMachine][].

[EventMachine]: http://rubyeventmachine.com/

## Supported Ruby Versions
This library aims to support and is [tested against][travis] the following Ruby
implementations:

* Ruby 1.8.7
* Ruby 1.9.2
* Ruby 1.9.3
* Ruby 2.0.0
* Ruby 2.1.0

If something doesn't work on one of these interpreters, it's a bug.

This library may inadvertently work (or seem to work) on other Ruby
implementations, however support will only be provided for the versions listed
above.

If you would like this library to support another Ruby version, you may
volunteer to be a maintainer. Being a maintainer entails making sure all tests
run and pass on that implementation. When something breaks on your
implementation, you will be responsible for providing patches in a timely
fashion. If critical issues for a particular implementation exist at the time
of a major release, support for that Ruby version may be dropped.

## Copyright
Copyright (c) 2006-2021 Tony Arcieri, Martin Emde, Erik Michaels-Ober.
Distributed under the [MIT license][license].
[license]: https://opensource.org/licenses/MIT
