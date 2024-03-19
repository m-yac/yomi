module Jekyll
  module PostTitleFilter
    def postTitle(book, chapter, verse, heTitle, tlTitle, enTitle)
      str = "#{book} #{chapter}"
      if verse
        str += ":#{verse}"
      end
      str += " – "
      if heTitle
        str += "<span class=\"he\">#{heTitle}</span>"
      end
      if tlTitle
        if tlTitle
          str += " "
        end
        str += "<span class=\"tl\">#{tlTitle}</span>"
      end
      if enTitle
        if heTitle || tlTitle
          str += ", "
        end
        str += "#{enTitle}"
      end
      return str
    end
  end

  class PostTitleTag < Liquid::Tag
    include PostTitleFilter

    def render(context)
      postTitle(
        context.environments.first["page"]["book"],
        context.environments.first["page"]["chapter"],
        context.environments.first["page"]["verse"],
        context.environments.first["page"]["heTitle"],
        context.environments.first["page"]["tlTitle"],
        context.environments.first["page"]["enTitle"])
    end
  end

  class PostTitleNoHTMLTag < Liquid::Tag
    include PostTitleFilter

    def render(context)
      postTitle(
        context.environments.first["page"]["book"],
        context.environments.first["page"]["chapter"],
        context.environments.first["page"]["verse"],
        context.environments.first["page"]["heTitle"],
        context.environments.first["page"]["tlTitle"],
        context.environments.first["page"]["enTitle"]
      ).gsub(/<[^>]*>/, "")
    end
  end
end

Liquid::Template.register_filter(Jekyll::PostTitleFilter)
Liquid::Template.register_tag('pagePostTitle', Jekyll::PostTitleTag)
Liquid::Template.register_tag('pagePostTitleNoHTML', Jekyll::PostTitleNoHTMLTag)
