def class_exists?(class_name)
  klass = Module.const_get(class_name)
  return klass.is_a?(Class)
rescue NameError
  return false
end

class Module
  def takes(*arg_names)
    define_method(:initialize) do |*arg_values|
      arg_names.zip(arg_values).each do |name, value|
        if name.is_a?(Hash)
          name, default_value = name.to_a.flatten
          value = default_value if value.blank?
        end

        instance_variable_set(:"@#{name}", value)
      end
    end
  end

  alias_method :let, :define_method
end
