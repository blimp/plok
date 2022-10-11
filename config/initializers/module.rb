class Module
  def takes(*arg_names)
    define_method(:initialize) do |*arg_values|
      arg_names.zip(arg_values).each do |name, value|
        if name.is_a?(Hash)
          name, default_value = name.to_a.flatten
          value = default_value if value.blank?
        end

        instance_variable_set(:"@#{name}", value)
        singleton_class.instance_eval { attr_reader name.to_sym }
      end
    end
  end

  alias_method :let, :define_method
end
