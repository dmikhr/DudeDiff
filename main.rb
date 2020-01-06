require_relative 'diff_params'

params_list1 =   [{ name: "AnotherCollection",
      :methods=>
       [{ name: :initialize, args: 1, length: 3, conditions: 0 },
        { name: :show, args: 0, length: 7, conditions: 2 },
        { name: :render, args: 2, length: 3, conditions: 0 },
        { name: :find, args: 0, length: 9, conditions: 1 }] },

        { name: "ThingCollection",
        :methods=>
          [{ name: :initialize, args: 1, length: 3, conditions: 0 },
          { name: :show, args: 0, length: 7, conditions: 2 },
          { name: :render, args: 2, length: 3, conditions: 0 },
          { name: :find, args: 0, length: 9, conditions: 1 }] },
      ]

params_list2 =   [{ name: "AnotherCollection",
      :methods=>
        [{ name: :initialize, args: 2, length: 10, conditions: 1 },
        { name: :show, args: 0, length: 3, conditions: 1 },
        { name: :render, args: 2, length: 3, conditions: 0 },
        { name: :new_method, args: 4, length: 12, conditions: 1 },
        { name: :new_method2, args: 2, length: 3, conditions: 0 }] }]


compare_methods = DiffParams.new(params_list1, params_list2)
puts compare_methods.diff_params
