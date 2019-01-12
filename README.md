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


## Development

Clone the git repository and you are good to go. You probably want to install
`rake` so that you can use the provided rake tasks.


## License

MIT - see the **COPYING** file.
