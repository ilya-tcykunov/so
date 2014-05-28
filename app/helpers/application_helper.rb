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

  def new_comments_for_id(commentable)
    "#{commentable.class.name.underscore}_#{commentable.id}"
  end

  def attachment_for_id(attachmentable)
    "#{attachmentable.class.name.underscore}_#{attachmentable.id}"
  end

  def bootstrap_icon_class(name)
    "fa fa-#{name}"
  end

  def bootstrap_icon(name)
    content_tag :i, '', {class: bootstrap_icon_class(name)}
  end

end