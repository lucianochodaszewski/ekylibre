class Dimension
  
  def initialize(name, unit)
    raise Exception, "dimension name #{name.inspect} is unvalid. Must be a Symbol." unless name.is_a? Symbol
    raise Exception, "dimension unit #{unit.inspect} is unvalid. Must be a Symbol." unless unit.is_a? Symbol
    @name = name
    @unit = unit
    @units = {unit=>1}
  end

  def units
    @units.keys
  end

  def has_unit?(unit)
    raise Exception, "dimension unit #{unit.inspect} is unvalid. Must be a Symbol." unless unit.is_a? Symbol
    return @units[unit].nil?
  end

  def unit(unit, factor)
    raise Exception, "dimension unit #{unit.inspect} is unvalid. Must be a Symbol." unless unit.is_a? Symbol
    @units[unit] = factor
    return nil
  end

end



class Measure

  def initialize(value, unit)
    @value, @unit = value, unit
    return nil
  end

  
  

end




class Measure
  class UnitRedefinitionError < StandardError; end
  class InvalidUnitError < StandardError; end
  class CompatibilityError < StandardError; end
 
  @@units = {}
  @@dimensions = {}
 
  class << self
 
    #
    # Tests presence of unit
    #
    def has_unit?(unit)
      begin
        return @@units[unit].nil?
      rescue
        return false;
      end
    end
  
    #
    # Test direct compatibility between two units, u1 and u2.
    #
    def direct_compatible?(u1, u2)
      u1 = resolve_alias u1
      u2 = resolve_alias u2
      return true if u1 == u2
      if @@conversion_map.has_key? u1 and @@conversion_map[u1].has_key? u2
        return true
      end
      if @@conversion_map.has_key? u2 and @@conversion_map[u2].has_key? u1
        return true unless Proc === @@conversion_map[u2][u1]
      end
      return false
    end
 
    #
    # Clear all defined units.
    #
    def clear_units
      @@units.clear
      @@dimensions.clear
      return nil
    end
 
    #
    # Returns defined units. If dimension is specified, returning
    # units are of only the dimension.
    #
    def units(dimension=nil)
      return @@units.dup if dimension.nil?
      return @@units.select{|k, v| v[:dimension]==dimension}.collect{|k,v|, k}
    end
 


    def define_dimension(dimension, unit)
      raise UnvalidDimension, "dimension #{dimension.inspect} is unvalid. Must be a Symbol." if dimension.is_a? Symbol
      raise UnvalidDimension, "dimension #{dimension.inspect} is unvalid. Must be a Symbol." if dimension.is_a? Symbol
      
    end

    #
    # Defines a unit. The default dimension is 1.
    # Measure::UnitRedefinitionError is raised when the unit is redefined.
    #
    def define_unit(unit, dimension)
      raise UnvalidDimension, "dimension #{dimension.inspect} is unvalid. Must be a Symbol." if dimension.is_a? Symbol
      raise UndefinedDimension, "dimension #{dimension.inspect} is undefined" if @@dimension[dimension].nil?

      if @@units.include?(unit)
        if self.dimension(unit) != dimension
          raise UnitRedefinitionError, "unit [#{unit}] is already defined"
        end
      else
        @@units << unit
        @@dimension_map[unit] = dimension
        return self
      end
    end
 
    alias def_unit define_unit
 
  end # class << self
 
  def initialize(value, unit)
    @value, @unit = value, unit
    return nil
  end
 
  attr_reader :value, :unit
 
  def <(other)
    case other
    when Measure
      if self.unit == other.unit
        return self.value < other.value
      else
        return self < other.convert(self.value)
      end
    when Numeric
      return self.value < other
    else
      raise ArgumentError, 'unable to compare with #{other.inspect}'
    end
  end
 
  def >(other)
    case other
    when Measure
      if self.unit == other.unit
        return self.value > other.value
      else
        return self > other.convert(self.value)
      end
    when Numeric
      return self.value > other
    else
      raise ArgumentError, 'unable to compare with #{other.inspect}'
    end
  end
 
  def ==(other)
    return self.value == other.value if self.unit == other.unit
    if Measure.direct_compatible? self.unit, other.unit
      return self == other.convert(self.unit)
    elsif Measure.direct_compatible? other.unit, self.unit
      return self.convert(other.unit) == other
    else
      return false
    end
  end
 
  def +(other)
    case other
    when Measure
      if self.unit == other.unit
        return Measure(self.value + other.value, self.unit)
      elsif Measure.dim(self.unit) == Measure.dim(other.unit)
        return Measure(self.value + other.convert(self.unit).value, self.unit)
      else
        raise TypeError, "incompatible dimensions: " +
          "#{Measure.dim(self.unit)} and #{Measure.dim(other.unit)}"
      end
    when Numeric
      return Measure(self.value + other, self.unit)
    else
      check_coercable other
      a, b = other.coerce self
      return a + b
    end
  end
 
  def -(other)
    case other
    when Measure
      if self.unit == other.unit
        return Measure(self.value - other.value, self.unit)
      elsif Measure.dim(self.unit) == Measure.dim(other.unit)
        return Measure(self.value - other.convert(self.unit).value, self.unit)
      else
        raise TypeError, "incompatible dimensions: " +
          "#{Measure.dim(self.unit)} and #{Measure.dim(other.unit)}"
      end
    when Numeric
      return Measure(self.value - other, self.unit)
    else
      check_coerecable other
      a, b = other.coerce self
      return a - b
    end
  end
 
  def *(other)
    case other
    when Measure
      return other * self.value if self.unit == 1
      return Measure(self.value * other.value, self.unit) if other.unit == 1
      # TODO: dimension
      raise NotImplementedError, "this feature has not implemented yet"
# if self.unit == other.unit
# return Measure(self.value * other.value, self.unit)
# elsif Measure.dim(self.unit) == Measure.dim(other.unit)
# return Measure(self.value - other.convert(self.unit).value, self.unit)
# else
# return Measure(self.value * other.convert(self.unit).value, self.unit)
# end
    when Numeric
      return Measure(self.value * other, self.unit)
    else
      check_coercable other
      a, b = other.coerce self
      return a * b
    end
  end
 
  def /(other)
    case other
    when Measure
      # TODO: dimension
      raise NotImplementedError, "this feature has not implemented yet"
# if self.unit == other.unit
# return Measure(self.value / other.value, self.unit)
# else
# return Measure(self.value / other.convert(self.unit).value, self.unit)
# end
    when Numeric
      return Measure(self.value / other, self.unit)
    else
      check_coercable other
      a, b = other.coerce self
      return a / b
    end
  end
 
  def coerce(other)
    case other
    when Numeric
      return [Measure(other, 1), self]
    else
      raise TypeError, "#{other.class} can't convert into #{self.class}"
    end
  end
 
  def abs
    return Measure(self.value.abs, self.unit)
  end
 
  def to_s
    return "#{self.value} [#{self.unit}]"
  end
 
  def to_a
    return [self.value, self.unit]
  end
 
  def convert(unit)
    return self if unit == self.unit
    to_unit = Measure.resolve_alias unit
    raise InvalidUnitError, "unknown unit: #{unit}" unless Measure.has_unit? unit
    from_unit = Measure.resolve_alias self.unit
    if Measure.direct_compatible? from_unit, to_unit
      # direct conversion
      if @@conversion_map.has_key? from_unit and @@conversion_map[from_unit].has_key? to_unit
        conv = @@conversion_map[from_unit][to_unit]
        case conv
        when Proc
          value = conv[self.value]
        else
          value = self.value * conv
        end
      else
        value = self.value / @@conversion_map[to_unit][from_unit].to_f
      end
    elsif route = Measure.find_multi_hop_conversion(from_unit, to_unit)
      u1 = route.shift
      value = self.value
      while u2 = route.shift
        if @@conversion_map.has_key? u1 and @@conversion_map[u1].has_key? u2
          conv = @@conversion_map[u1][u2]
          case conv
          when Proc
            value = conv[vaule]
          else
            value *= conv
          end
        else
          value /= @@conversion_map[u2][u1].to_f
        end
        u1 = u2
      end
    else
      raise CompatibilityError, "units not compatible: #{self.unit} and #{unit}"
    end
    # Second
    return Measure.new(value, unit)
  end
 
  alias saved_method_missing method_missing
  private_methods :saved_method_missing
 
  def method_missing(name, *args)
    if /^as_(\w+)/.match(name.to_s)
      unit = $1.to_sym
      return convert(unit)
    end
    return saved_method_missing(name, *args)
  end
 
  private
 
  def check_coercable(other)
    unless other.respond_to? :coerce
      raise TypeError, "#{other.class} can't be coerced into #{self.class}"
    end
  end
end
 
def Measure(value, unit=1)
  return Measure.new(value, unit)
end








class Measure
  attr_reader :unit

  UNIT_NATURES = {
    'length'=>{:ref=>'m'},
    'angle'=>{:ref=>'rad'},
    'percent'=>{:ref=>'%'}
  }

  UNITS = {
    'mm'=>{:nature=>UNIT_NATURES['length'][:ref], :factor=>0.001},
    'cm'=>{:nature=>UNIT_NATURES['length'][:ref], :factor=>0.01},
    'dm'=>{:nature=>UNIT_NATURES['length'][:ref], :factor=>0.1},
    'm'=> {:nature=>UNIT_NATURES['length'][:ref], :factor=>1},
    'km'=>{:nature=>UNIT_NATURES['length'][:ref], :factor=>1000},
    'pt'=>{:nature=>UNIT_NATURES['length'][:ref], :factor=>0.0254/72},
    'pc'=>{:nature=>UNIT_NATURES['length'][:ref], :factor=>0.0254/6},
    'in'=>{:nature=>UNIT_NATURES['length'][:ref], :factor=>0.0254}, # 2.54cm
    'ft'=>{:nature=>UNIT_NATURES['length'][:ref], :factor=>12*0.0254}, # 12 in
    'yd'=>{:nature=>UNIT_NATURES['length'][:ref], :factor=>3*12*0.0254},  # 3 ft
    'mi'=>{:nature=>UNIT_NATURES['length'][:ref], :factor=>1760*3*12*0.0254}, # 1760 yd
    'gon'=>{:nature=>UNIT_NATURES['angle'][:ref], :factor=>Math::PI/200},
    'deg'=>{:nature=>UNIT_NATURES['angle'][:ref], :factor=>Math::PI/180},
    'rad'=>{:nature=>UNIT_NATURES['angle'][:ref], :factor=>1},
    '%'=>{:nature=>UNIT_NATURES['percent'][:ref], :factor=>0.01}
  }

  
  def initialize(value, options={})
    unit = options[:unit]
    if value.is_a? self.class
      value = self.to_f
      unit = self.unit
    elsif value.is_a? String
      numeric = value[/\d*\.?\d*/]
      raise ArgumentError.new("Unvalid value: #{value.inspect}") if numeric.nil?
      unit = value[/[a-z\%]+/]
    else
      numeric = value
    end
    begin
      @value = numeric.to_f
    rescue
      raise ArgumentError.new("Value can't be converted to float: #{value.inspect}")
    end
    raise ArgumentError.new("Unknown unit: #{unit.inspect} in #{value.inspect}") unless UNITS.keys.include? unit
    if options[:nature]
      raise ArgumentError.new("Unvalid unit: #{unit.inspect} in #{value.inspect}. #{options[:nature]} expected") unless UNITS[unit][:nature] == options[:nature]
    end
    @unit = unit
    self
  end


  def to_m(unit)
    Measure.new(self.to_f(unit), unit)
  end

  def inspect
    self.to_s
  end
  
  def to_s
    @value.to_f.to_s+@unit
  end
  
  def nature
    UNITS[@unit][:nature]
  end

  def +(measure)
    @value += measure.to_f(@unit)
  end

  def -(measure)
    @value -= measure.to_f(@unit)
  end

  def to_f(unit=nil)
    if unit.nil?
      @value
    else
      raise Exception.new("Unknown unit: #{unit.inspect}") unless UNITS.keys.include? unit
      raise Exception.new("Measure can't be converted from one system (#{UNITS[@unit][:nature].inspect}) to an other (#{UNITS[unit][:nature].inspect})") if UNITS[@unit][:nature]!=UNITS[unit][:nature]
      @value*UNITS[@unit][:factor]/UNITS[unit][:factor]
    end
  end
  
end


