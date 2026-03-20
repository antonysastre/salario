require "date"

module Salario
  # Calculates workable hours for a given month, accounting for public holidays.
  module WorkingHours
    Result = Struct.new(
      :year, :month,
      :total_days, :weekdays, :holidays_on_weekdays,
      :workable_days, :workable_hours,
      :holiday_list,
      keyword_init: true
    )

    # Returns a Result for the given year/month.
    #
    # Options:
    #   hours_per_day: standard hours per full working day (default: 8)
    def self.for_month(year, month, hours_per_day: STANDARD_HOURS_PER_DAY)
      first = Date.new(year, month, 1)
      last  = Date.new(year, month, -1)
      range = first..last

      all_holidays = Holidays.for_year(year)

      # Holidays that fall on a weekday (Mon-Fri) in this month
      holidays_in_month = all_holidays.select { |h| range.cover?(h.date) && weekday?(h.date) }

      weekdays = range.count { |d| weekday?(d) }
      holiday_weekday_count = holidays_in_month.size

      workable_days = weekdays - holiday_weekday_count
      workable_hours = workable_days * hours_per_day

      Result.new(
        year: year,
        month: month,
        total_days: range.count,
        weekdays: weekdays,
        holidays_on_weekdays: holiday_weekday_count,
        workable_days: workable_days,
        workable_hours: workable_hours,
        holiday_list: holidays_in_month,
      )
    end

    def self.weekday?(date)
      !date.saturday? && !date.sunday?
    end
    private_class_method :weekday?
  end
end
