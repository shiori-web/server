class ActiveModelUniquenessValidator < ActiveRecord::Validations::UniquenessValidator
  def initialize(opts)
    super
    @klass = opts[:model] if opts[:model]
  end

  def validate_each(record, attribute, value)
    if !options[:model] && !record.class.ancestors.include?(ActiveRecord::Base)
      fail ArgumentError, "Unknown validator: ActiveModelUniquenessValidator"
    elsif !options[:model]
      super
    else
      rec, att = record, attribute
      attribute = options[:attribute].to_sym if options[:attribute]
      record = options[:model].new(attribute => value)

      super
      if record.errors.any?
        rec.errors.add(att, :taken, options.except(:case_sensitive, :scope).merge(value: value))
      end
    end
  end
end
