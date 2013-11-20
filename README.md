# BufferedTokenizer

[![Gem Version](https://badge.fury.io/rb/buftok.png)][gem]
[![Build Status](https://travis-ci.org/sferik/buftok.png?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/sferik/buftok.png?travis)][gemnasium]
[![Code Climate](https://codeclimate.com/github/sferik/buftok.png)][codeclimate]

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

## Copyright
Copyright (c) 2006-2013 Tony Arcieri, Martin Emde.
Distributed under the [Ruby license][license].

[license]: http://www.ruby-lang.org/en/LICENSE.txt
