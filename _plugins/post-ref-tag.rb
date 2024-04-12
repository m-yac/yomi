module Jekyll
  module PostRefHelper
    def post_ref_helper(context, text)
      m = text.scan(/([A-Za-z]+(?: +[A-Za-z]+)*) ([0-9]+)/)[0]
      for post in context.environments.first["site"]["posts"]
        if post["book"] == m[0] and post["chapter"].to_s == m[1].to_s
          return context.environments.first["site"]["baseurl"].to_s + post.url
        end
      end
      raise "Could not find matching post!"
    end
  end

  class PostRefTag < Liquid::Tag    
    include PostRefHelper

    def initialize(tag_name, text, tokens)
      super
      @text = text.strip
    end
  
    def render(context)
      post_ref_helper(context, @text)
    end
  end

  class MyNotesOnTag < Liquid::Tag    
    include PostRefHelper

    def initialize(tag_name, text, tokens)
      super
      @text = text.strip
    end
  
    def render(context)
      "<a href=\"#{post_ref_helper(context, @text)}\">my notes on #{@text}</a>"
    end
  end
end

Liquid::Template.register_tag('post_ref', Jekyll::PostRefTag)
Liquid::Template.register_tag('my_notes_on', Jekyll::MyNotesOnTag)
