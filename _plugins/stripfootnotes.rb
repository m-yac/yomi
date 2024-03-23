# Adapted from: https://battlepenguin.com/tech/removing-footnotes-from-excerpts-in-jekyll/
# https://gist.github.com/sumdog/99bf642024cc30f281bc#file-stripfootnotes-rb

require 'nokogiri'

module Jekyll
  module StripFootnotesFilter

    def strip_footnotes(raw, url)
      doc = Nokogiri::HTML.fragment(raw.encode('UTF-8', :invalid => :replace, :undef => :replace, :replace => ''))

      for block in ['div', 'sup', 'a'] do
        doc.css(block).each do |ele|
          if ele['class'] == 'footnotes'
            ele.remove
          elsif ele['class'] == 'footnote'
            ele.attributes["href"].value = url + ele.attributes["href"].value
          end
        end
      end

      doc.inner_html

    end
  end
end

Liquid::Template.register_filter(Jekyll::StripFootnotesFilter)