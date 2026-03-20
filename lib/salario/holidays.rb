require "date"

module Salario
  # Swedish public holidays (allmänna helgdagar) per SFS 1989:253.
  #
  # Returns an array of hashes: { date:, name:, name_sv: }
  module Holidays
    def self.for_year(year)
      easter = Easter.sunday(year)

      holidays = [
        # Fixed holidays
        fixed(year, 1, 1,   "New Year's Day",       "Nyårsdagen"),
        fixed(year, 1, 6,   "Epiphany",             "Trettondedag jul"),
        fixed(year, 5, 1,   "May Day",              "Första maj"),
        fixed(year, 12, 25, "Christmas Day",         "Juldagen"),
        fixed(year, 12, 26, "Second Day of Christmas", "Annandag jul"),

        # National Day (public holiday since 2005)
        (fixed(year, 6, 6, "National Day of Sweden", "Sveriges nationaldag") if year >= 2005),

        # Easter-dependent holidays
        movable(easter - 2,  "Good Friday",     "Långfredagen"),
        movable(easter - 1,  "Easter Saturday",  "Påskafton"),
        movable(easter,      "Easter Sunday",    "Påskdagen"),
        movable(easter + 1,  "Easter Monday",    "Annandag påsk"),
        movable(easter + 39, "Ascension Day",    "Kristi himmelsfärdsdag"),
        movable(easter + 49, "Whit Sunday",      "Pingstdagen"),

        # Whit Monday was a public holiday until 2004
        (movable(easter + 50, "Whit Monday", "Annandag pingst") if year < 2005),

        # Midsummer's Day: Saturday between June 20-26
        saturday_between(year, 6, 20, 6, 26, "Midsummer's Day", "Midsommardagen"),

        # All Saints' Day: Saturday between Oct 31 - Nov 6
        saturday_between(year, 10, 31, 11, 6, "All Saints' Day", "Alla helgons dag"),
      ].compact

      holidays.sort_by(&:date)
    end

    Holiday = Struct.new(:date, :name, :name_sv, keyword_init: true)

    class << self
      private

      def fixed(year, month, day, name, name_sv)
        Holiday.new(date: Date.new(year, month, day), name: name, name_sv: name_sv)
      end

      def movable(date, name, name_sv)
        Holiday.new(date: date, name: name, name_sv: name_sv)
      end

      def saturday_between(year, start_month, start_day, end_month, end_day, name, name_sv)
        start_date = Date.new(year, start_month, start_day)
        end_date   = Date.new(year, end_month, end_day)
        date = start_date
        date += 1 until date.saturday?
        raise Error, "No Saturday found in range #{start_date}..#{end_date}" if date > end_date
        Holiday.new(date: date, name: name, name_sv: name_sv)
      end
    end
  end
end
