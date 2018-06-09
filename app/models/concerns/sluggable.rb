module Sluggable
  extend ActiveSupport::Concern

  included do
    include FriendlyId
    friendly_id :slug_candidates, use: [:slugged, :history]

    before_save -> { self.slug = nil if slug.blank? }
  end
end
