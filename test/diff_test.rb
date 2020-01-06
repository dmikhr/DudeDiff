require 'test/unit'
require 'byebug'
require_relative '../diff'


class TestUtils < Test::Unit::TestCase

  def test_comparison
    params1 = { name: "AnotherCollection",
      :methods=> [{ name: :initialize, args: 1, length: 3, conditions: 0 }] }
    params2 = { name: "AnotherCollection",
      :methods=> [{ name: :initialize, args: 2, length: 1, conditions: 1 }] }

    compare_methods = DiffMethods.new(params1, params2).diff

    method = compare_methods[:methods].first
    assert_equal(method[:args], [2, 1])
    assert_equal(method[:length], [1, -2])
    assert_equal(method[:conditions], [1, 1])
  end

  def test_new_method
    params1 = { name: "AnotherCollection",
      :methods=> [{ name: :initialize, args: 1, length: 3, conditions: 0 }] }
    params2 = { name: "AnotherCollection",
      :methods=> [{ name: :initialize, args: 2, length: 1, conditions: 1 },
                  { name: :scan, args: 1, length: 10, conditions: 0 }] }

    compare_methods = DiffMethods.new(params1, params2).diff

    method = compare_methods[:methods].first
    assert_equal(method[:name], [:scan, 1])
  end

  def test_removed_method
    params1 = { name: "AnotherCollection",
      :methods=> [{ name: :initialize, args: 1, length: 3, conditions: 0 },
                  { name: :old, args: 1, length: 10, conditions: 0 }] }
    params2 = { name: "AnotherCollection",
      :methods=> [{ name: :initialize, args: 2, length: 1, conditions: 1 }] }

    compare_methods = DiffMethods.new(params1, params2).diff

    method = compare_methods[:methods].first
    assert_equal(method[:name], [:old, -1])
  end
end
