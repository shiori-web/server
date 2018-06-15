module IndexTranslatable
  extend ActiveSupport::Concern

  TRANSLATION_MAPPINGS = {
    'ja_*' => 'cjk',
    'zh_*' => 'cjk',
    'ko_*' => 'cjk',
    'en_*' => 'english'
  }.freeze

  class_methods do
    def translatable_field(name, opts = {})
      field name, { type: 'object' }.merge(opts)
      TRANSLATION_MAPPINGS.each do |lang, analyzer|
        template "#{name}.#{lang}", type: 'string', analyzer: analyzer
      end
    end
  end
end
