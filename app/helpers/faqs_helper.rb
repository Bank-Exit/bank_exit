module FAQsHelper
  # This method parses FAQ content that have some {{mustach}}
  # dynamic variables such as a Rails route.
  def parsed_faq_answer(answer)
    mustaches = answer.scan(/\{\{[^}]+\}\}(?!\})/)
    mustaches.each do |mustache|
      mustache.gsub!('{{', '').gsub!('}}', '')

      delimiters = ['#', '->']
      controller, action, id = mustache.split(Regexp.union(delimiters))

      link = url_for(controller: controller, action: action, id: id)

      label = link

      # Find article title to be used as text for link
      if controller.in?(%w[tutorials blogs]) && id
        resource = controller.classify.constantize.find(id)
        label = resource.title
      end

      answer.gsub!(mustache, link_to(label, link))
            .gsub!('{{', '')&.gsub!('}}', '')
    end

    answer
  end
end
