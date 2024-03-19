module Jekyll
  module HeFilter
    def he(input, tl = nil, tr = nil)
      str = "<span class=\"he\" dir=\"rtl\">#{input}</span>"
      if tl || tr
        str += " ("
        if tl
          str += "<span class=\"tl\">#{tl}</span>"
        end
        if tl && tr
          str += "; "
        end
        if tr
          str += "“<span class=\"tr\">#{tr}</span>”"
        end
        str += ")"
      end
      return str
    end
  end

  module SefariaFilter
    def sefaria(input)
      match = input.scan(/^([0-9A-Za-z ]+) ([0-9]+):([0-9]+).*/)
      "<a href=\"https://www.sefaria.org/#{match[0][0]}.#{match[0][1]}.#{match[0][2]}\">#{input}</a>"
    end
  end
end

Liquid::Template.register_filter(Jekyll::HeFilter)
Liquid::Template.register_filter(Jekyll::SefariaFilter)
