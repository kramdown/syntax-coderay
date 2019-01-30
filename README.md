# kramdown syntax highlighter based on Coderay

This is a syntax highlighter for [kramdown](https://kramdown.gettalong.org)
that uses [coderay](http://coderay.rubychan.de/) to highlight code blocks and
spans when converting to HTML.

Note: Until kramdown version 2.0.0 this math engine was part of the kramdown
distribution.


## Installation

~~~ruby
gem install kramdown-syntax-coderay
~~~


## Usage

~~~ruby
require 'kramdown'
require 'kramdown-syntax-coderay'

Kramdown::Document.new(text, syntax_highlighter: :coderay).to_html
~~~


## Documentation

To use Coderay, set the option `syntax_highlighter` to 'coderay' and make sure that Coderay is
available. The Coderay library can be installed, e.g., via Rubygems by running `gem install
coderay`.

> Note that the 'coderay_*' options are deprecated and should not be used anymore!

The Coderay syntax highlighter supports the following keys of the option `syntax_highlighter_opts`:

* span:

  A key-value map of options that are only used when syntax highlighting code spans.

* block:

  A key-value map of options that are only used when syntax highlighting code blocks.

* default_lang:

  The default language that should be used when no language is set for a **code block**.

Furthermore all Coderay options (e.g. `css`, `line_numbers`, `line_numbers_start`, `bold_every`,
`tab_width`, `wrap`) can be set directly on the `syntax_highlighter_opts` option (where they apply
to code spans *and* code blocks) and/or on the `span`/`block` keys.

Here is an example that shows how Ruby code is highlighted:

    require 'kramdown'

    Kramdown::Document.new('* something').to_html
    puts 1 + 1


## Development

Clone the git repository and you are good to go. You probably want to install
`rake` so that you can use the provided rake tasks.


## License

MIT - see the **COPYING** file.
