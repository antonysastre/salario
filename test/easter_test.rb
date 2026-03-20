require "test_helper"

class EasterTest < Minitest::Test
  # Known Easter Sunday dates for verification
  KNOWN_EASTERS = {
    2020 => Date.new(2020, 4, 12),
    2021 => Date.new(2021, 4, 4),
    2022 => Date.new(2022, 4, 17),
    2023 => Date.new(2023, 4, 9),
    2024 => Date.new(2024, 3, 31),
    2025 => Date.new(2025, 4, 20),
    2026 => Date.new(2026, 4, 5),
    2027 => Date.new(2027, 3, 28),
    2028 => Date.new(2028, 4, 16),
    2029 => Date.new(2029, 4, 1),
    2030 => Date.new(2030, 4, 21),
  }.freeze

  KNOWN_EASTERS.each do |year, expected|
    define_method("test_easter_#{year}") do
      assert_equal expected, Salario::Easter.sunday(year)
    end
  end

  def test_easter_is_always_a_sunday
    (2000..2050).each do |year|
      assert Salario::Easter.sunday(year).sunday?, "Easter #{year} should be a Sunday"
    end
  end
end
