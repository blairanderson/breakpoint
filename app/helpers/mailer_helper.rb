module MailerHelper
  def formatted_from(from_name, email = ActionMailer::Base.default[:from])
    from = Mail::Address.new(email)
    from.display_name = from_name.dup
    from.format
  end

  def formatted_changes(changes)
    content_tag :ul do
      changes.map do |attribute, values|
        content_tag :li do
          old_value = '-'
          new_value = '-'
          if values[0].respond_to?(:utc) || values[1].respond_to?(:utc)
            old_value = l(values[0].in_time_zone, :format => :long) if values[0].present?
            new_value = l(values[1].in_time_zone, :format => :long) if values[1].present?
            "<strong>#{attribute.titleize}</strong> changed <strong>from</strong> #{old_value} <strong>to</strong> #{new_value}".html_safe
          else
            "<strong>#{attribute.titleize}</strong> changed".html_safe
          end
        end
      end.join.html_safe
    end
  end

  def build_ics(match, from_name)
    event          = Icalendar::Event.new
    event.dtstart  = match.date
    event.dtend    = match.date.advance(:hours => 3)
    event.summary  = "Tennis Match"
    event.location = match.location
    if match.comment.present?
      event.description = %Q{Match comments:

#{match.comment}

Thanks,
#{from_name}}
    end

    cal = Icalendar::Calendar.new
    cal.add_event(event)
    cal.to_ical
  end
end

