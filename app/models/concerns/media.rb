module Media
  extend ActiveSupport::Concern

  included do
    include Seasonal
    include Titleable
  end
end
