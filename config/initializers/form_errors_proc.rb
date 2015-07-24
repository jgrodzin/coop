ActionView::Base.field_error_proc = proc do |html_tag, instance|
  if html_tag =~ /\<label/
    errors = Array(instance.error_message).last
    "#{html_tag}<span class=\"validation-error\">&nbsp;#{errors}</span>".html_safe
  else
    "<div class=\"field_with_errors\">#{html_tag}</div>".html_safe
  end
end
