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
end

Liquid::Template.register_filter(Jekyll::HeFilter)
