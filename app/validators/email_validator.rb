class EmailValidator < ActiveModel::EachValidator
  EACH = '[a-zA-Z0-9\._\-]+'.freeze
  EMAIL_FORMAT = /#{EACH}@#{EACH}\.\w{2,}/i.freeze

  def validate_each(record, attribute, value)
    record.errors.add(attribute, message) unless email?(value)
  end

  private

  def email?(value)
    value =~ EMAIL_FORMAT
  end

  def message
    options[:message] || I18n.t('errors.messages.not_email')
  end
end
