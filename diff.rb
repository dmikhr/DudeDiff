class DiffMethods
  attr_reader :diff

  def initialize(params1, params2)
    @params1 = params1
    @params2 = params2
    @diff = { name: @params2[:name], :methods=> [] }

    compare
  end

  private

  def compare
    new_methods_names,
    removed_methods_names,
    unchanged_methods_names = methods_diff(@params1[:methods], @params2[:methods])

    new_methods = label_methods(@params2[:methods], new_methods_names, 1)
    removed_methods = label_methods(@params1[:methods], removed_methods_names, -1)

    @diff[:methods] << new_methods
    @diff[:methods] << removed_methods
    process_unchanged_methods(unchanged_methods_names)

    remove_empty
    @diff[:methods].flatten!
  end

  # returns hash with method2 params and diff (e.g. args2 - args1)
  def compare_methods(method1, method2)
    args_diff = method2[:args] - method1[:args]
    length_diff = method2[:length] - method1[:length]
    conditions_diff = method2[:conditions] - method1[:conditions]
    { name: [method1[:name], 0],
      args: [method2[:args], args_diff],
      length: [method2[:length], length_diff],
      conditions: [method2[:conditions], conditions_diff] }
  end

  def methods_diff(methods1, methods2)
    methods_names1 = method_names(methods1)
    methods_names2 = method_names(methods2)

    new_methods = methods_names2 - methods_names1
    removed_methods = methods_names1 - methods_names2
    unchanged_methods = methods_names2 - new_methods

    [new_methods, removed_methods, unchanged_methods]
  end

  def method_names(methods)
    methods.map { |method| method[:name] }
  end

  def find_method(methods, name)
    method = methods.select { |method| method[:name] == name }
    method.first unless method.nil?
  end

  # 0 - unchanged, -1 - removed, 1 - new
  def label_method(methods, method_name, label)
    method = find_method(methods, method_name)
    method[:name] = [method[:name], label]
    method
  end

  def label_methods(methods, method_names, label)
    method_names.map { |method_name| label_method(methods, method_name, label) }
  end

  def process_unchanged_methods(unchanged_methods_names)
    unchanged_methods_names.each do |method_name|
      method1 = find_method(@params1[:methods], method_name)
      method2 = find_method(@params2[:methods], method_name)
      @diff[:methods] << compare_methods(method1, method2)
    end

    unchanged_methods = label_methods(@params1[:methods], unchanged_methods_names, 0)
  end

  def remove_empty
    @diff[:methods].select! { |item| item != [] }
  end
end
