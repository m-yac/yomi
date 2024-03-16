module Jekyll
    module HeFilter
      def he(input, tl = nil, tr = nil)
        str = "<span class=\"he\">#{input}</span>"
        if tl || tr
          str += " (<span class=\"tltr\">"
          if tl
            str += "<span class=\"tl\">#{tl}</span>"
          end
          if tl && tr
            str += " – "
          end
          if tr
            str += "“<span class=\"tr\">#{tr}</span>”"
          end
          str += "</span>)"
        end
        return str
      end
    end
  end
  
  Liquid::Template.register_filter(Jekyll::HeFilter)