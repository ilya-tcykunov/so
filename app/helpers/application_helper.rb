module ApplicationHelper
  def error_messages(model)
    return '' if model.errors.blank?

    concat(content_tag(:div, class: 'alert alert-danger'){
      concat(content_tag(:button, '&times;'.html_safe, class: 'close', data: {dismiss: 'alert'}, area_hidden: 'true'))
      concat(content_tag(:ul){
        model.errors.full_messages.each do |msg|
          concat(content_tag(:li, msg))
        end
      })
    })
  end
end