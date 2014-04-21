class PriceValidator < Apipie::Validator::BaseValidator

  def initialize(param_description, argument)
    super(param_description)
    @type = argument
  end

  def validate(value)
    return false if value.nil? || !value.is_a?(String)
    !!(value.to_s =~ /^[1-9]*.[0-9]{2}$/)
  end

  def self.build(param_description, argument, options, block)
    if argument == :price
      self.new(param_description, argument)
    end
  end

  def description
    "#{@param_description}"
  end

  def expected_type
    'positive float with 2 decimal digits'
  end

end

class CurrencyValidator < Apipie::Validator::BaseValidator

  def initialize(param_description, argument)
    super(param_description)
    @type = argument
    @currencies = ['EUR']
  end

  def validate(value)
    return false if value.nil? || !value.is_a?(String)
    @currencies.include? value
  end

  def self.build(param_description, argument, options, block)
    if argument == :currency
      self.new(param_description, argument)
    end
  end

  def description
    "#{@param_description}"
  end

  def expected_type
    "currency as string [#{@currencies.join(', ')}]"
  end

end

class PositiveIntegerValidator < Apipie::Validator::BaseValidator

  def initialize(param_description, argument)
    super(param_description)
    @type = argument
  end

  def validate(value)
    return false if value.nil? || !value.is_a?(String)
    !!(value.to_s =~ /^\d+$/)
  end

  def self.build(param_description, argument, options, block)
    if argument == :integer
      self.new(param_description, argument)
    end
  end

  def description
    "#{@param_description}"
  end

  def expected_type
    'positive integer'
  end

end

class DevicePlatformValidator < Apipie::Validator::BaseValidator

  def initialize(param_description, argument)
    super(param_description)
    @type = argument
    @platforms = ['ios']
  end

  def validate(value)
    return false if value.nil? || !value.is_a?(String)
    @platforms.include? value
  end

  def self.build(param_description, argument, options, block)
    if argument == :device_platform
      self.new(param_description, argument)
    end
  end

  def description
    "#{@param_description}"
  end

  def expected_type
    "device platform as string [#{@platforms.join(', ')}]"
  end

end

class LatitudeValidator < Apipie::Validator::BaseValidator

  def initialize(param_description, argument)
    super(param_description)
    @type = argument
  end

  def validate(value)
    return false if value.nil? || !value.is_a?(String)
    converted = value.to_f
    converted.to_s == value && converted > -90 && converted < 90
  end

  def self.build(param_description, argument, options, block)
    if argument == :latitude
      self.new(param_description, argument)
    end
  end

  def description
    "#{@param_description}"
  end

  def expected_type
    'valid latitude in float'
  end

end

class LongitudeValidator < Apipie::Validator::BaseValidator

  def initialize(param_description, argument)
    super(param_description)
    @type = argument
  end

  def validate(value)
    return false if value.nil? || !value.is_a?(String)
    converted = value.to_f
    converted.to_s == value && converted > -180 && converted < 180
  end

  def self.build(param_description, argument, options, block)
    if argument == :longitude
      self.new(param_description, argument)
    end
  end

  def description
    "#{@param_description}"
  end

  def expected_type
    'valid longitude in float'
  end

end