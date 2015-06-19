module ApplicationHelper
  def flash_name_for_bootstrap(name)
    name = name.to_s
    mapping = {
      "alert"  => { :class => 'warning', :icon => 'warning-sign' },
      "notice" => { :class => 'success', :icon => 'ok-sign' },
      "info"   => { :class => 'info',    :icon => 'info-sign' },
      "error"  => { :class => 'danger',  :icon => 'exclamation-sign' }
    }

    mapping.fetch(name, { :class => name, :icon => 'info-sign' })
  end

  def active_tab(kontroller_name, &block)
    class_name = controller_name.include?(kontroller_name) ? 'active' : nil
    content_tag :li, :class => class_name do
      capture(&block)
    end
  end

  def match_result_class(match)
    return 'alert-info' unless match.has_results?
    match.won? ? 'alert-success' : 'alert-error'
  end

  def availability_label(status)
    status = status.downcase.gsub(" ", "_")
    case status
    when "yes"
      "success"
    when "maybe"
      "info"
    when "no"
      "danger"
    when "no_response"
      "warning"
    end
  end
end

