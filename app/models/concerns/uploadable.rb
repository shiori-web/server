module Uploadable
  extend ActiveSupport::Concern

  class_methods do
    def uploadable_field(field, opts = {})
      class_eval do
        attr_accessor "base64_#{field}_filename".to_sym
        has_one_attached field
      end

      define_method "base64_#{field}=" do |encoded|
        content = encoded.sub(/\Adata:(.+)\/(.+);base64,/, '')
        io = StringIO.new(Base64.decode64(content))
        filename = public_send("base64_#{field}_filename")
        public_send(field).attach(io: io, filename: filename)
      end

      define_method "#{field}_url" do
        image = public_send(field)
        return unless image.attached?
        UrlService.url_for image
      end

      if versions = opts[:versions]
        versions.each do |version, flag|
          define_method "#{version}_#{field}_url" do
            image = public_send(field)
            return unless image.attached?
            UrlService.url_for image.variant(resize: flag)
          end
        end
      end
    end
  end
end
