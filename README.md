# BufferedTokenizer

[![Gem Version](http://img.shields.io/gem/v/buftok.svg)][gem]
[![Test](https://github.com/sferik/buftok/actions/workflows/test.yml/badge.svg)][test]
[![Lint](https://github.com/sferik/buftok/actions/workflows/lint.yml/badge.svg)][lint]
[![Type Check](https://github.com/sferik/buftok/actions/workflows/typecheck.yml/badge.svg)][typecheck]
[![Mutation Testing](https://github.com/sferik/buftok/actions/workflows/mutant.yml/badge.svg)][mutant]
[![Documentation Coverage](https://github.com/sferik/buftok/actions/workflows/yardstick.yml/badge.svg)][yardstick]

[gem]: https://rubygems.org/gems/buftok
[test]: https://github.com/sferik/buftok/actions/workflows/test.yml
[lint]: https://github.com/sferik/buftok/actions/workflows/lint.yml
[typecheck]: https://github.com/sferik/buftok/actions/workflows/typecheck.yml
[mutant]: https://github.com/sferik/buftok/actions/workflows/mutant.yml
[yardstick]: https://github.com/sferik/buftok/actions/workflows/yardstick.yml

###### Statefully split input data by a specifiable token

BufferedTokenizer takes a delimiter upon instantiation, or acts line-based by
default. It allows input to be spoon-fed from some outside source which
receives arbitrary length datagrams which may-or-may-not contain the token by
which entities are delimited. It's useful any time you need to extract
delimited messages from a stream of chunked data.

## Examples

### TCP Server

Process newline-delimited commands from a TCP client:

```ruby
require "socket"
require "buftok"

server = TCPServer.new(4000)

loop do
  client = server.accept
  tokenizer = BufferedTokenizer.new("\n")

  while (data = client.readpartial(4096))
    tokenizer.extract(data).each do |line|
      puts "Received: #{line}"
    end
  end
rescue EOFError
  client.close
end
```

### Streaming IO

Read a large file in chunks without loading it all into memory:

```ruby
require "buftok"

tokenizer = BufferedTokenizer.new("\n")

File.open("large_log_file.txt") do |file|
  while (chunk = file.read(8192))
    tokenizer.extract(chunk).each do |line|
      process_log_line(line)
    end
  end
end

# Don't forget to flush any remaining data
remaining = tokenizer.flush
process_log_line(remaining) unless remaining.empty?
```

> [!IMPORTANT]
> Always call `flush` when you're done reading from the stream to process any
> remaining data that didn't end with a delimiter.

### Custom Delimiters

Parse a stream using a multi-character delimiter:

```ruby
require "buftok"

tokenizer = BufferedTokenizer.new("\r\n\r\n")

chunks = ["HTTP/1.1 200 OK\r\n", "Content-Type: text/plain\r\n\r\n", "Hello"]

chunks.each do |chunk|
  tokenizer.extract(chunk).each do |headers|
    puts "Headers: #{headers}"
  end
end

puts "Body so far: #{tokenizer.flush}"
```

> [!TIP]
> Multi-character delimiters that get split across chunks are handled
> automatically — no special handling is needed on your end.

## Supported Ruby Versions
This library aims to support and is [tested against][test] the following Ruby
implementations:

* Ruby 3.2
* Ruby 3.3
* Ruby 3.4
* Ruby 4.0

If something doesn't work on one of these interpreters, it's a bug.

This code will likely still work on older Ruby versions but support will not be
provided for end-of-life versions.

If you would like this library to support another Ruby version, you may
volunteer to be a maintainer. Being a maintainer entails making sure all tests
run and pass on that implementation. When something breaks on your
implementation, you will be responsible for providing patches in a timely
fashion. If critical issues for a particular implementation exist at the time
of a major release, support for that Ruby version may be dropped.

## Copyright
Copyright (c) 2006-2026 Tony Arcieri, Martin Emde, Erik Berlin.
Distributed under the [MIT license][license].

[license]: https://opensource.org/licenses/MIT
