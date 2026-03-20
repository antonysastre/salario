require "date"

module Salario
  # Computes Easter Sunday for a given year using the Anonymous Gregorian algorithm.
  module Easter
    def self.sunday(year)
      metonic_cycle    = year % 19
      century, year_in_century = year.divmod(100)
      leap_correction, leap_remainder = century.divmod(4)
      sync_correction  = (century + 8) / 25
      lunar_correction = (century - sync_correction + 1) / 3
      paschal_moon     = (19 * metonic_cycle + century - leap_correction - lunar_correction + 15) % 30
      day_correction, day_remainder = year_in_century.divmod(4)
      weekday_offset   = (32 + 2 * leap_remainder + 2 * day_correction - paschal_moon - day_remainder) % 7
      leap_adjustment  = (metonic_cycle + 11 * paschal_moon + 22 * weekday_offset) / 451
      month, day       = (paschal_moon + weekday_offset - 7 * leap_adjustment + 114).divmod(31)
      Date.new(year, month, day + 1)
    end
  end
end
