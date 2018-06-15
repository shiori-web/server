module SearchableResource
  extend ActiveSupport::Concern

  class_methods do
    attr_reader :_chewy_index, :_query_fields

    def index(index)
      @_chewy_index = index
    end

    def inherited(base)
      base.instance_variable_set(:@_chewy_index, @_chewy_index)
      base.instance_variable_set(:@_query_fields, @_query_fields)
      super
    end

    def query(field, opts = {})
      field = field.to_sym

      filter field, verify: opts[:verify] || ->(values, context) do
        if valid = opts[:valid]
          values if !values.blank? && values.all? { |value| valid.call(value, context) }
        else
          values
        end
      end

      @_query_fields ||= {}
      @_query_fields[field] = opts
    end

    def should_query?(filters)
      return false unless filters.respond_to?(:keys)
      return false unless @_query_fields
      filters.keys.any? { |key| @_query_fields.include?(key) }
    end

    def find_records(filters, opts = {})
      return super unless should_query?(filters)
      return [] if filters.values.any?(&:nil?)

      load_query_records(apply_scopes(filters, opts), opts)
    end

    def load_query_records(query, opts = {})
      include_directives = opts[:include_directives]
      return query.load.objects unless include_directives

      model_includes = resolve_relationship_names_to_relations(
        self, include_directives.model_includes, opts)

      query.load(scope: -> { includes(model_includes) }).objects
    end

    def find_count(filters, opts = {})
      return super unless should_query?(filters)
      return 0 if filters.values.any?(&:nil?)
      apply_scopes(filters, opts).total_count
    end

    def sortable_fields(context = nil)
      @_query_fields ||= {}
      if searchable?
        super + @_query_fields.keys + ['_score']
      else
        super
      end
    end

    def searchable?
      @_query_fields.present?
    end

    private

    def apply_scopes(filters, opts = {})
      context = opts[:context]
      query = generate_query(filters)
      query = query.reduce(@_chewy_index) do |scope, subquery|
        scope.public_send(*subquery.values_at(:mode, :query))
      end

      query = opts[:paginator].apply(query, {}) if opts[:paginator]

      if opts[:sort_criteria]
        query = opts[:sort_criteria].reduce(query) do |scope, sort|
          field = sort[:field] == 'id' ? '_score' : sort[:field]
          scope.order(field => sort[:direction])
        end
      else
        query = query.order('_score' => :desc)
      end
      query = search_scope_policy.new(context[:user], query).resolve

      query
    end

    def search_scope_policy
      Pundit::PolicyFinder.new(_model_class).scope!
    end

    def generate_query(filters)
      @_query_fields.map do |field, opts|
        next unless filters.key?(field)

        filter = filters[field]
        filter = opts[:apply].call(filter, {}) if opts[:apply]

        { mode: opts[:mode] || :filter, query: auto_query(field, filter) }
      end.compact
    end

    def auto_query(field, value)
      case value
      when String, Integer, Float, Date
        { match: { field => value } }
      when Range
        { range: { field => { gte: value.min, lte: value.max } } }
      when Array
        if value.all? { |v| v.is_a?(String) || v.is_a?(Numeric) }
          auto_query(value.join(' '))
        else
          matchers = value.map { |v| auto_query(field, v) }
          { bool: { should: matchers } }
        end
      when Hash
        value.deep_transform_keys { |key| key.to_s == '$field' ? field : key }
      else
        value
      end
    end
  end
end
