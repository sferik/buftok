# BufferedTokenizer

[![Gem Version](http://img.shields.io/gem/v/buftok.svg)][gem]
[![Build Status](https://github.com/sferik/buftok/actions/workflows/ruby.yml/badge.svg)][build]

[gem]: https://rubygems.org/gems/buftok
[build]: https://github.com/sferik/buftok/actions

###### Statefully split input data by a specifiable token

BufferedTokenizer takes a delimiter upon instantiation, or acts line-based by
default.  It allows input to be spoon-fed from some outside source which
receives arbitrary length datagrams which may-or-may-not contain the token by
which entities are delimited.  In this respect it's ideally paired with
something like [EventMachine][].

[EventMachine]: http://rubyeventmachine.com/

## Supported Ruby Versions
This library aims to support and is [tested against][build] the following Ruby
implementations:

* Ruby 2.6
* Ruby 2.7
* Ruby 3.0

If something doesn't work on one of these interpreters, it's a bug.

This code will likely still work on older versions since it has not undergone
many changes since release. However, support will not be provided for
end-of-life ruby versions.

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
