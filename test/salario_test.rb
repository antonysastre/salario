require "test_helper"

class SalarioTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Salario::VERSION
  end

  def test_public_holidays_returns_array
    holidays = Salario.public_holidays(2026)
    assert_kind_of Array, holidays
    assert holidays.all? { |h| h.respond_to?(:date) && h.respond_to?(:name) && h.respond_to?(:name_sv) }
  end

  def test_working_hours_returns_result
    result = Salario.working_hours(2026, 3)
    assert_respond_to result, :workable_hours
    assert_respond_to result, :workable_days
    assert_respond_to result, :weekdays
  end
end
