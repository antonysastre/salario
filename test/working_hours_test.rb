require "test_helper"

class WorkingHoursTest < Minitest::Test
  # January 2026:
  #   31 days, weekdays: 22
  #   Holidays on weekdays: Jan 1 (Thu), Jan 6 (Tue) = 2
  #   Workable days: 22 - 2 = 20
  #   Hours: 20 * 8 = 160
  def test_january_2026
    result = Salario.working_hours(2026, 1)
    assert_equal 2026, result.year
    assert_equal 1, result.month
    assert_equal 22, result.weekdays
    assert_equal 2, result.holidays_on_weekdays  # Jan 1 (Thu), Jan 6 (Tue)
    assert_equal 20, result.workable_days
    assert_equal 160, result.workable_hours
  end

  # June 2026:
  #   30 days, weekdays: 22
  #   Holidays on weekdays: Jun 6 (Sat - NOT a weekday) => 0 weekday holidays
  #     Midsummer's Day Jun 20 is Saturday => not a weekday
  #   Workable days: 22 - 0 = 22
  #   Hours: 22 * 8 = 176
  def test_june_2026
    result = Salario.working_hours(2026, 6)
    assert_equal 22, result.weekdays
    assert_equal 0, result.holidays_on_weekdays
    assert_equal 22, result.workable_days
    assert_equal 176, result.workable_hours
  end

  # December 2026:
  #   31 days, weekdays: 23
  #   Holidays on weekdays: Dec 25 (Fri) = 1
  #   Workable days: 23 - 1 = 22
  #   Hours: 22 * 8 = 176
  def test_december_2026
    result = Salario.working_hours(2026, 12)
    assert_equal 23, result.weekdays
    assert_equal 1, result.holidays_on_weekdays  # Christmas Day (Fri)
    assert_equal 22, result.workable_days
    assert_equal 176, result.workable_hours
  end

  # April 2026:
  #   Easter Sunday = April 5
  #   Good Friday April 3 (Fri) - holiday
  #   Easter Monday April 6 (Mon) - holiday
  #   30 days, weekdays: 22
  #   Holidays on weekdays: Good Friday (Fri 3), Easter Monday (Mon 6) = 2
  #   Workable days: 22 - 2 = 20
  #   Hours: 20 * 8 = 160
  def test_april_2026
    result = Salario.working_hours(2026, 4)
    assert_equal 22, result.weekdays
    assert_equal 2, result.holidays_on_weekdays
    assert_equal 20, result.workable_days
    assert_equal 160, result.workable_hours
  end

  # May 2026:
  #   31 days, weekdays: 21
  #   Holidays on weekdays: May 1 (Fri), Ascension Day May 14 (Thu) = 2
  #   Workable days: 21 - 2 = 19
  #   Hours: 19 * 8 = 152
  def test_may_2026
    result = Salario.working_hours(2026, 5)
    assert_equal 21, result.weekdays
    assert_equal 2, result.holidays_on_weekdays
    assert_equal 19, result.workable_days
    assert_equal 152, result.workable_hours
  end

  def test_custom_hours_per_day
    result = Salario::WorkingHours.for_month(2026, 3, hours_per_day: 7.5)
    # March 2026: 22 weekdays, no holidays
    assert_equal 22, result.weekdays
    assert_equal 0, result.holidays_on_weekdays
    assert_in_delta 165.0, result.workable_hours, 0.01
  end

  def test_holiday_list_populated
    result = Salario.working_hours(2026, 1)
    names = result.holiday_list.map(&:name_sv)
    assert_includes names, "Nyårsdagen"
    assert_includes names, "Trettondedag jul"
  end

  # A month with no holidays
  def test_plain_month
    # March 2026: no holidays
    result = Salario.working_hours(2026, 3)
    assert_equal 22, result.weekdays
    assert_equal 0, result.holidays_on_weekdays
    assert_equal 22, result.workable_days
    assert_equal 176, result.workable_hours
  end
end
