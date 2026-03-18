# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- RBS type signatures in `sig/buftok.rbs` with Steep for strict type checking
- RuboCop, Standard, rubocop-minitest, rubocop-performance, and rubocop-rake for linting
- Mutant for mutation testing with 100% coverage
- GitHub Actions workflows for linting, type checking, and mutation testing
- `.github/FUNDING.yml` for GitHub Sponsors
- Gemspec metadata (`allowed_push_host`, `changelog_uri`, `documentation_uri`,
  `funding_uri`, `homepage_uri`, `rubygems_mfa_required`, `source_code_uri`,
  `bug_tracker_uri`)
- `CHANGELOG.md`

### Changed

- Require Ruby >= 3.2
- Require RubyGems >= 3.0
- Test against Ruby 3.2, 3.3, 3.4, and 4.0 (drop EOL 2.6, 2.7, 3.0)
- Update `actions/checkout` to v6 and `ruby/setup-ruby` to v1
- Replace test-unit with Minitest 6
- Replace `inject` with `sum` in `size` method
- Use `@tail.clear` instead of `String.new` in `flush` (drop Ruby 1.8.7 workaround)
- Move development dependencies from gemspec to Gemfile
- Bump rake from `~> 10.0` to `>= 13`
- Extract `rejoin_split_delimiter` and `consolidate_input` private methods
- Update copyright years to 2006-2026
- Rename Erik Michaels-Ober to Erik Berlin

### Fixed

- Typo in test comment ("Desipte" -> "Despite")

## [0.3.0] - 2021-03-25

### Added

- `Buftok` constant as an alias for `BufferedTokenizer`
- `BufferedTokenizer#size` method to determine internal buffer size
- GitHub Actions CI workflow
- Support for `frozen_string_literal`

### Changed

- Replace Ruby license with MIT license
- Modernize gemspec
- Remove Travis CI in favor of GitHub Actions
- Update supported Ruby versions to 2.6, 2.7, 3.0

## [0.2.0] - 2013-11-22

### Added

- Tests
- Benchmark rake task
- Support for multi-character delimiters split across chunks
- Section on supported Ruby versions in README

### Changed

- Use global input delimiter `$/` as default instead of hard-coded `"\n"`
- Unified handling of single/multi-character delimiters

## [0.1.0] - 2013-11-20

### Added

- Initial release of BufferedTokenizer
- Line-based tokenization with configurable delimiter
- `extract` method for incremental tokenization
- `flush` method to retrieve remaining buffer contents

[Unreleased]: https://github.com/sferik/buftok/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/sferik/buftok/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/sferik/buftok/compare/v0.1...v0.2.0
[0.1.0]: https://github.com/sferik/buftok/releases/tag/v0.1
