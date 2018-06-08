module Titleable
  extend ActiveSupport::Concern

  included do
    validates :titles, presence: true
    validate :has_en_title

    def sub_titles=(titles)
      self[:sub_titles] =
        case titles
        when Array, Range
          titles.map(&:to_s)
        else
          [titles.to_s]
        end
    end
  end

  private

  def has_en_title?
    titles.keys.any? { |key| key.start_with?('en_') }
  end

  def has_en_title
    errors.add(:titles, I18n.t('errors.messages.en_title_not_exist')) unless has_en_title?
  end
end
