module DateParser
  def self.included(base)
    base.class_eval do
      attr_writer :date_string
      validates_presence_of :date_string
      before_save :set_date
    end
  end

  def date_string
    if @date_string.present?
      @date_string
    else
      I18n.localize date unless date.nil?
    end
  end

  private

  def set_date
    Chronic.time_class = Time.zone
    self.date = Chronic.parse("#{date_string}")
  end
end

