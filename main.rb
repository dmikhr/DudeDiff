require_relative 'diff'

params1 =   { name: "AnotherCollection",
      :methods=>
       [{ name: :initialize, args: 1, length: 3, conditions: 0 },
        { name: :show, args: 0, length: 7, conditions: 2 },
        { name: :render, args: 2, length: 3, conditions: 0 },
        { name: :find, args: 0, length: 9, conditions: 1 }] }

params2 =   { name: "AnotherCollection",
      :methods=>
        [{ name: :initialize, args: 2, length: 10, conditions: 1 },
        { name: :show, args: 0, length: 3, conditions: 1 },
        { name: :render, args: 2, length: 3, conditions: 0 },
        { name: :new_method, args: 4, length: 12, conditions: 1 },
        { name: :new_method2, args: 2, length: 3, conditions: 0 }] }

compare_methods = DiffMethods.new(params1, params2)
puts compare_methods.diff
