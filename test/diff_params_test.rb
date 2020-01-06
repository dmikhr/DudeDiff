require 'test/unit'
require 'byebug'
require_relative '../diff_params'


class TestUtils < Test::Unit::TestCase

  def test_comparison
    params1 = [{ name: "AnotherCollection",
      :methods=> [{ name: :initialize, args: 1, length: 3, conditions: 0 }]}]
    params2 = [{ name: "AnotherCollection",
      :methods=> [{ name: :initialize, args: 2, length: 1, conditions: 1 }]}]

    compare_methods = DiffParams.new(params1, params2).diff_params

    method = compare_methods.first[:methods].first
    assert_equal(method[:args], [2, 1])
    assert_equal(method[:length], [1, -2])
    assert_equal(method[:conditions], [1, 1])
  end

  def test_new_method
    params1 = [{ name: "AnotherCollection",
      :methods=> [{ name: :initialize, args: 1, length: 3, conditions: 0 }]}]
    params2 = [{ name: "AnotherCollection",
      :methods=> [{ name: :initialize, args: 2, length: 1, conditions: 1 },
                  { name: :scan, args: 1, length: 10, conditions: 0 }]}]

    compare_methods = DiffParams.new(params1, params2).diff_params

    method = compare_methods.first[:methods].first
    assert_equal(method[:name], [:scan, 1])
  end

  def test_removed_method
    params1 = [{ name: "AnotherCollection",
      :methods=> [{ name: :initialize, args: 1, length: 3, conditions: 0 },
                  { name: :old, args: 1, length: 10, conditions: 0 }]}]
    params2 = [{ name: "AnotherCollection",
      :methods=> [{ name: :initialize, args: 2, length: 1, conditions: 1 }]}]

    compare_methods = DiffParams.new(params1, params2).diff_params

    method = compare_methods.first[:methods].first
    assert_equal(method[:name], [:old, -1])
  end

  def test_unchanged_method
    params1 = [{ name: "AnotherCollection",
      :methods=> [{ name: :initialize, args: 1, length: 3, conditions: 0 },
                  { name: :old, args: 1, length: 10, conditions: 0 }]}]
    params2 = [{ name: "AnotherCollection",
      :methods=> [{ name: :initialize, args: 1, length: 3, conditions: 0 },
                  { name: :old, args: 1, length: 10, conditions: 0 }]}]

    compare_methods = DiffParams.new(params1, params2).diff_params

    method = compare_methods.first[:methods].first
    assert_equal(method[:args], [1, 0])
    assert_equal(method[:length], [3, 0])
    assert_equal(method[:conditions], [0, 0])
  end

  def test_new_params
    params1 = [{ name: "AnotherCollection",
      :methods=> [{ name: :initialize, args: 1, length: 3, conditions: 0 },
                  { name: :old, args: 1, length: 10, conditions: 0 }] }]
    params2 = [{ name: "AnotherCollection",
      :methods=> [{ name: :initialize, args: 2, length: 1, conditions: 1 }]},
              { name: "NewCollection",
      :methods=> [{ name: :initialize, args: 2, length: 5, conditions: 1 }]}]

    compare_params = DiffParams.new(params1, params2).diff_params

    params = compare_params.first.first
    assert_equal(params[:name], ["NewCollection", 1])
  end

  def test_unchanged_params
    params1 = [{ name: "AnotherCollection",
      :methods=> [{ name: :initialize, args: 1, length: 3, conditions: 0 },
                  { name: :old, args: 1, length: 10, conditions: 0 }] }]
    params2 = [{ name: "AnotherCollection",
      :methods=> [{ name: :initialize, args: 2, length: 1, conditions: 1 }]}]

    compare_params = DiffParams.new(params1, params2).diff_params

    params = compare_params.first
    assert_equal(params[:name], ["AnotherCollection", 0])
  end
end
