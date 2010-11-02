class Errata
  class Erratum
    attr_accessor :errata, :column, :options
    delegate :responder, :to => :errata
    
    def initialize(errata, options = {})
      raise "you can't set this from outside" if options[:prefix].present?
      @errata = errata
      @column = options[:section]
      @options = options
    end
    
    def matching_methods
      @_matching_methods ||= options[:condition].split(/\s*;\s*/).map do |method_id|
        "#{method_id.strip.gsub(/[^a-z0-9]/i, '_').downcase}?"
      end
    end
    
    def inspect
      "<#{self.class.name}:#{object_id} responder=#{responder.to_s} column=#{column} matching_methods=#{matching_methods.inspect}"
    end
    
    def targets?(row)
      !!(conditions_match?(row) and expression_matches?(row))
    end
    
    def correct!(row, &block)
      return :skipped unless targets?(row)
      yield if block_given?
      :corrected
    end

    def expression_matches?(row)
      return true if @matching_expression.nil? or column.blank?
      if @matching_expression.is_a?(Regexp)
        @matching_expression.match(row[column].to_s)
      else
        row[column].to_s.include?(@matching_expression)
      end
    end
    
    def conditions_match?(row)
      matching_methods.all? { |method_id| responder.send method_id, row }
    end
    
    def set_matching_expression(options = {})
      expression = options[:x]
      return nil if expression.blank? 

      if expression.encoding == Encoding::ASCII_8BIT # ASCII-8BIT is Ruby 1.9's failsafe encoding
        expression = expression.force_encoding('UTF-8') 
      end

      if expression.start_with?('/')
        if expression.end_with?('i')
          ci = true
          expression = expression.chop
        else
          ci = false
        end
        @matching_expression = Regexp.new(expression.gsub(/\A\/|\/\z/, ''), ci)
      elsif /\Aabbr\((.*)\)\z/.match(expression)
        @matching_expression = Regexp.new('(\A|\s)' + $1.split(/(\w\??)/).reject { |a| a == '' }.join('\.?\s?') + '\.?([^\w\.]|\z)', true)
      elsif options[:prefix] == true
        @matching_expression = Regexp.new('\A\s*' + Regexp.escape(expression), true)
      else
        @matching_expression = expression
      end
    end
  end
end
