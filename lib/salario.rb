require "salario/version"
require "salario/easter"
require "salario/holidays"
require "salario/working_hours"

module Salario
  class Error < StandardError; end

  STANDARD_HOURS_PER_DAY = 8

  # Returns all public holidays (red days) for a given year.
  def self.public_holidays(year)
    Holidays.for_year(year)
  end

  # Returns a WorkingHours summary for a given year and month.
  def self.working_hours(year, month)
    WorkingHours.for_month(year, month)
  end
end
