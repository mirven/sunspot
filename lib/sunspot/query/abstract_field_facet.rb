module Sunspot
  module Query
    class AbstractFieldFacet
      def initialize(field, options)
        @field, @options = field, options
      end

      def to_params
        params = {
          :facet => 'true',
        }
        case @options[:sort]
        when :count
          params[qualified_param('sort')] = 'true'
        when :index
          params[qualified_param('sort')] = 'false'
        when nil
        else
          raise(
            ArgumentError,
            "#{@options[:sort].inspect} is not an allowed value for :sort. Allowed options are :count and :index"
          )
        end
        if @options[:limit]
          params[qualified_param('limit')] = @options[:limit].to_i
        end
        params[qualified_param('mincount')] = 
          case
          when @options[:minimum_count] then @options[:minimum_count].to_i
          when @options[:zeros] then 0
          else 1
          end
        params
      end

      private

      def qualified_param(param)
        :"f.#{@field.indexed_name}.facet.#{param}"
      end
    end
  end
end
