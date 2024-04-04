module Jekyll
  class VersesTag < Liquid::Tag
    def render(context)
      "<div class=\"verses\"><table><tbody><tr>"
    end
  end

  class ScaledVersesTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      size = @text.strip
      "<div class=\"verses verses-scaled\" style=\"font-size: #{size}%;\"><table><tbody><tr>"
    end
  end

  class HeVerseTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      "<td class=\"he\" dir=\"rtl\">#{@text}</td>"
    end
  end

  class GkVerseTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      "<td class=\"gk\">#{@text}</td>"
    end
  end

  class TlVerseTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      "<td class=\"tl\">#{@text}</td>"
    end
  end

  class TrVerseTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      "<td class=\"tr\">#{@text}</td>"
    end
  end

  class BrVersesTag < Liquid::Tag
    def render(context)
      "</tr><tr>"
    end
  end

  class BrDotsVersesTag < Liquid::Tag
    def render(context)
      "</tr><tr><td class=\"he\" dir=\"rtl\">…</td><td class=\"tl\">…</td><td class=\"tr\">…</td></tr><tr>"
    end
  end
  
  module SefariaFilter
    def sefaria(input)
      book = input.scan(/^([A-Za-z]+(:? +[A-Za-z]+)*)/)[0][0]
      chapter = nil
      str = ""
      input.scan(/([;,] ?|-)?((?:([1-9][0-9a-z]*):)?([1-9][0-9a-z]*))/).each_with_index { |m, i|
        if m[2]
          chapter = m[2]
        end
        str += "#{m[0]}<a href=\"https://www.sefaria.org/#{book}."
        if chapter
          str += "#{chapter}."
        end
        str += "#{m[3]}\" class=\"sefaria-link\">"
        if i == 0
          str += "#{book} "
        end
        str += "#{m[1]}</a>"
      }
      return str
    end
  end

  class EndVersesTag < Liquid::Tag
    include SefariaFilter

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      str = "</tr></tbody></table><div class=\"verses-attrib\">"
      str += sefaria(@text)
      str += "</div></div>"
      return str
    end
  end

  class EndVersesNoLinkTag < Liquid::Tag
    include SefariaFilter

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      str = "</tr></tbody></table><div class=\"verses-attrib\">"
      str += @text
      str += "</div></div>"
      return str
    end
  end
end

Liquid::Template.register_tag('verses', Jekyll::VersesTag)
Liquid::Template.register_tag('scaledverses', Jekyll::ScaledVersesTag)
Liquid::Template.register_tag('vhe', Jekyll::HeVerseTag)
Liquid::Template.register_tag('vgk', Jekyll::GkVerseTag)
Liquid::Template.register_tag('vtl', Jekyll::TlVerseTag)
Liquid::Template.register_tag('vtr', Jekyll::TrVerseTag)
Liquid::Template.register_tag('brverses', Jekyll::BrVersesTag)
Liquid::Template.register_tag('brdotsverses', Jekyll::BrDotsVersesTag)
Liquid::Template.register_tag('endverses', Jekyll::EndVersesTag)
Liquid::Template.register_tag('endversesnolink', Jekyll::EndVersesNoLinkTag)
Liquid::Template.register_filter(Jekyll::SefariaFilter)
