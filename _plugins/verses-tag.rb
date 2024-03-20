module Jekyll
  class VersesTag < Liquid::Tag
    def render(context)
      "<div class=\"verses\"><table><tbody><tr>"
    end
  end

  class NoWrapVersesTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      size = @text.strip
      "<div class=\"verses verses-no-wrap\" style=\"font-size: #{size}%;\"><table><tbody><tr>"
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
  
  class EndVersesTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      book = @text.scan(/^([A-Za-z ]+)/)[0][0]
      str = "</tr></tbody></table><div class=\"verses-attrib\">"
      @text.scan(/(,? )?([0-9]+):([0-9]+)/).each_with_index { |m, i|
        str += "<a href=\"https://www.sefaria.org/#{book}.#{m[1]}.#{m[2]}\">"
        if i == 0
          str += "#{book}"
        end
        str += "#{m[0]}#{m[1]}:#{m[2]}</a>"
      }
      str += "</div></div>"
      return str
    end
  end
end

Liquid::Template.register_tag('verses', Jekyll::VersesTag)
Liquid::Template.register_tag('nowrapverses', Jekyll::NoWrapVersesTag)
Liquid::Template.register_tag('vhe', Jekyll::HeVerseTag)
Liquid::Template.register_tag('vtl', Jekyll::TlVerseTag)
Liquid::Template.register_tag('vtr', Jekyll::TrVerseTag)
Liquid::Template.register_tag('brverses', Jekyll::BrVersesTag)
Liquid::Template.register_tag('brdotsverses', Jekyll::BrDotsVersesTag)
Liquid::Template.register_tag('endverses', Jekyll::EndVersesTag)
