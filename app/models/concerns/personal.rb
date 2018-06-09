module Personal
  extend ActiveSupport::Concern

  included do
    include Nameable

    enum gender: %i[male female na]
  end
end
