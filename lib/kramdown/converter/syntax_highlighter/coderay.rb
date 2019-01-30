# -*- coding: utf-8; frozen_string_literal: true -*-
#
#--
# Copyright (C) 2019 Thomas Leitner <t_leitner@gmx.at>
#
# This file is part of kramdown-syntax-coderay which is licensed under the MIT.
#++
#

require 'kramdown/options'
require 'kramdown/converter'
require 'coderay'

module Kramdown #:nodoc:

  module Options #:nodoc:

    define(:enable_coderay, Boolean, true, <<EOF)
Use coderay for syntax highlighting

If this option is `true`, coderay is used by the HTML converter for
syntax highlighting the content of code spans and code blocks.

Default: true
Used by: HTML converter
EOF

    define(:coderay_wrap, Symbol, :div, <<EOF)
Defines how the highlighted code should be wrapped

The possible values are :span, :div or nil.

Default: :div
Used by: HTML converter
EOF

    define(:coderay_line_numbers, Symbol, :inline, <<EOF)
Defines how and if line numbers should be shown

The possible values are :table, :inline or nil. If this option is
nil, no line numbers are shown.

Default: :inline
Used by: HTML converter
EOF

    define(:coderay_line_number_start, Integer, 1, <<EOF)
The start value for the line numbers

Default: 1
Used by: HTML converter
EOF

    define(:coderay_tab_width, Integer, 8, <<EOF)
The tab width used in highlighted code

Used by: HTML converter
EOF

    define(:coderay_bold_every, Object, 10, <<EOF) do |val|
Defines how often a line number should be made bold

Can either be an integer or false (to turn off bold line numbers
completely).

Default: 10
Used by: HTML converter
EOF
      if val == false || val.to_s == 'false'
        false
      else
        Integer(val.to_s) rescue raise Kramdown::Error, "Invalid value for option 'coderay_bold_every'"
      end
    end

    define(:coderay_css, Symbol, :style, <<EOF)
Defines how the highlighted code gets styled

Possible values are :class (CSS classes are applied to the code
elements, one must supply the needed CSS file) or :style (default CSS
styles are directly applied to the code elements).

Default: style
Used by: HTML converter
EOF

    define(:coderay_default_lang, Symbol, nil, <<EOF)
Sets the default language for highlighting code blocks

If no language is set for a code block, the default language is used
instead. The value has to be one of the languages supported by coderay
or nil if no default language should be used.

Default: nil
Used by: HTML converter
EOF

  end

  module Converter #:nodoc:
    module SyntaxHighlighter #:nodoc:

      # Uses Coderay to highlight code blocks and code spans.
      module Coderay

        VERSION = '1.0.1'

        def self.call(converter, text, lang, type, call_opts)
          return nil unless converter.options[:enable_coderay]
          if type == :span && lang
            ::CodeRay.scan(text, lang.to_sym).html(options(converter, :span)).chomp
          elsif type == :block && (lang || options(converter, :default_lang))
            lang ||= call_opts[:default_lang] = options(converter, :default_lang)
            ::CodeRay.scan(text, lang.to_s.tr('-', '_').to_sym).html(options(converter, :block)).chomp << "\n"
          else
            nil
          end
        rescue StandardError
          converter.warning("There was an error using CodeRay: #{$!.message}")
          nil
        end

        def self.options(converter, type)
          prepare_options(converter)
          converter.data[:syntax_highlighter_coderay][type]
        end

        def self.prepare_options(converter)
          return if converter.data.key?(:syntax_highlighter_coderay)

          cache = converter.data[:syntax_highlighter_coderay] = {}

          opts = converter.options[:syntax_highlighter_opts].dup
          span_opts = (opts.delete(:span) || {}).dup
          block_opts = (opts.delete(:block) || {}).dup
          [span_opts, block_opts].each do |hash|
            hash.keys.each do |k|
              hash[k.kind_of?(String) ? ::Kramdown::Options.str_to_sym(k) : k] = hash.delete(k)
            end
          end

          cache[:default_lang] = converter.options[:coderay_default_lang] || opts.delete(:default_lang)
          cache[:span] = {
            css: converter.options[:coderay_css],
          }.update(opts).update(span_opts).update(wrap: :span)
          cache[:block] = {
            wrap: converter.options[:coderay_wrap],
            line_numbers: converter.options[:coderay_line_numbers],
            line_number_start: converter.options[:coderay_line_number_start],
            tab_width: converter.options[:coderay_tab_width],
            bold_every: converter.options[:coderay_bold_every],
            css: converter.options[:coderay_css],
          }.update(opts).update(block_opts)

          [:css, :wrap, :line_numbers].each do |key|
            [:block, :span].each do |type|
              cache[type][key] = cache[type][key].to_sym if cache[type][key].kind_of?(String)
            end
          end
        end

      end
    end

    add_syntax_highlighter(:coderay, SyntaxHighlighter::Coderay)

  end

end
