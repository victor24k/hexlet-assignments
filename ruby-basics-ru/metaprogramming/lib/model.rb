# frozen_string_literal: true

# BEGIN
module Model
  # Implements class level method attribute.
  module ClassMethods
    def attribute(name, options = {})
      @specified_attributes ||= []

      define_method name do
        instance_variable_get "@#{name}"
      end

      type = options[:type]
      define_method "#{name}=" do |value|
        value = cast_value value, type if value && type

        instance_variable_set "@#{name}", value
      end

      self.instance_variable_get(:@specified_attributes) << { name: name, options: options }
    end
  end

  require 'date'

  def self.included(base)
    base.extend(ClassMethods)
  end

  def initialize(attributes = {})
    self.class.instance_variable_get(:@specified_attributes).each do |details|
      attribute = details[:name]
      default_value = details.dig(:options, :default)
      method("#{attribute}=").call(default_value)
    end

    attributes.each_pair do |attribute, value|
      method("#{attribute}=").call(value) if methods.include? attribute
    end
  end

  def attributes
    self.class.instance_variable_get(:@specified_attributes).each_with_object({}) do |details, acc|
      attribute = details[:name]
      acc[attribute] = method(attribute).call
    end
  end

  protected

  def cast_value(value, type)
    case type
    when :integer then Integer value
    when :string then String value
    when :boolean then value == true
    when :datetime then DateTime.parse value
    else raise 'Unsupported type'
    end
  end
end
# END
