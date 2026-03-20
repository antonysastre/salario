require "test_helper"

class HolidaysTest < Minitest::Test
  def test_2026_contains_new_years_day
    holidays = Salario::Holidays.for_year(2026)
    nyd = holidays.find { |h| h.name_sv == "Nyårsdagen" }
    assert nyd
    assert_equal Date.new(2026, 1, 1), nyd.date
  end

  def test_2026_contains_epiphany
    holidays = Salario::Holidays.for_year(2026)
    h = holidays.find { |h| h.name_sv == "Trettondedag jul" }
    assert h
    assert_equal Date.new(2026, 1, 6), h.date
  end

  def test_2026_good_friday
    # Easter 2026 is April 5, so Good Friday is April 3
    holidays = Salario::Holidays.for_year(2026)
    gf = holidays.find { |h| h.name_sv == "Långfredagen" }
    assert gf
    assert_equal Date.new(2026, 4, 3), gf.date
    assert gf.date.friday?
  end

  def test_2026_ascension_day_is_thursday
    holidays = Salario::Holidays.for_year(2026)
    ad = holidays.find { |h| h.name_sv == "Kristi himmelsfärdsdag" }
    assert ad
    assert ad.date.thursday?, "Ascension Day should always be a Thursday"
    # Easter 2026 = April 5, +39 = May 14
    assert_equal Date.new(2026, 5, 14), ad.date
  end

  def test_2026_midsummer
    holidays = Salario::Holidays.for_year(2026)
    ms = holidays.find { |h| h.name_sv == "Midsommardagen" }
    assert ms
    assert ms.date.saturday?
    assert ms.date >= Date.new(2026, 6, 20)
    assert ms.date <= Date.new(2026, 6, 26)
    # 2026: June 20 is Saturday
    assert_equal Date.new(2026, 6, 20), ms.date
  end

  def test_2026_all_saints_day
    holidays = Salario::Holidays.for_year(2026)
    asd = holidays.find { |h| h.name_sv == "Alla helgons dag" }
    assert asd
    assert asd.date.saturday?
    assert asd.date >= Date.new(2026, 10, 31)
    assert asd.date <= Date.new(2026, 11, 6)
    # 2026: Oct 31 is Saturday
    assert_equal Date.new(2026, 10, 31), asd.date
  end

  def test_national_day_included_from_2005
    holidays_2005 = Salario::Holidays.for_year(2005)
    nd = holidays_2005.find { |h| h.name_sv == "Sveriges nationaldag" }
    assert nd
    assert_equal Date.new(2005, 6, 6), nd.date
  end

  def test_national_day_not_included_before_2005
    holidays_2004 = Salario::Holidays.for_year(2004)
    nd = holidays_2004.find { |h| h.name_sv == "Sveriges nationaldag" }
    assert_nil nd
  end

  def test_whit_monday_included_before_2005
    holidays_2004 = Salario::Holidays.for_year(2004)
    wm = holidays_2004.find { |h| h.name_sv == "Annandag pingst" }
    assert wm
  end

  def test_whit_monday_not_included_from_2005
    holidays_2005 = Salario::Holidays.for_year(2005)
    wm = holidays_2005.find { |h| h.name_sv == "Annandag pingst" }
    assert_nil wm
  end

  def test_holidays_sorted_by_date
    holidays = Salario::Holidays.for_year(2026)
    dates = holidays.map(&:date)
    assert_equal dates.sort, dates
  end

  def test_count_2026
    # 2026: 14 red days:
    # 6 fixed (NYD, Epiphany, May Day, National Day, Christmas, Boxing Day)
    # 6 Easter-based (Good Friday, Easter Sat, Easter Sun, Easter Mon, Ascension, Whit Sun)
    # 2 movable Saturdays (Midsummer's Day, All Saints' Day)
    holidays = Salario::Holidays.for_year(2026)
    assert_equal 14, holidays.size
  end
end
