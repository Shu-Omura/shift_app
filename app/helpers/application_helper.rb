module ApplicationHelper
  def bootstrap_class_for(message_type)
    case message_type
    when 'success'
      'success'
    when 'error', 'alert'
      'danger'
    when 'notice'
      'info'
    else
      message_type.to_s
    end
  end
end
