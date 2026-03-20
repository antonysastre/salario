# Salario

A Ruby gem for Swedish salary system calculations.
Provides workable hours per month and public holidays (*röda dagar*) according to Swedish law (SFS 1989:253).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'salario'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install salario

## Usage

### Public holidays

Returns all Swedish public holidays (*allmänna helgdagar*) for a given year, including fixed dates, Easter-dependent dates, and movable Saturdays.

```ruby
Salario.public_holidays(2026)
# => [#<Holiday date=2026-01-01 name="New Year's Day" name_sv="Nyårsdagen">,
#     #<Holiday date=2026-01-06 name="Epiphany" name_sv="Trettondedag jul">,
#     ...]
```

Each holiday has `date`, `name` (English), and `name_sv` (Swedish) attributes.

Historical accuracy: National Day (June 6) is included from 2005 onward; Whit Monday (*Annandag pingst*) is included before 2005.

### Working hours per month

Calculates workable hours for a specific month, accounting for weekends and public holidays.

```ruby
result = Salario.working_hours(2026, 4)

result.weekdays              # => 22
result.holidays_on_weekdays  # => 2   (Good Friday, Easter Monday)
result.workable_days         # => 20
result.workable_hours        # => 160
result.holiday_list          # => detailed holiday structs for the month
```

#### Options

**Custom hours per day** — for collective agreements with shorter weeks (e.g. 37.5h):

```ruby
Salario::WorkingHours.for_month(2026, 3, hours_per_day: 7.5)
```

## What's included

| Category | Details |
|---|---|
| **Public holidays** | 14 *röda dagar* per SFS 1989:253 — fixed dates, Easter-dependent, and movable Saturdays (Midsummer, All Saints) |
| **Easter** | Computed via the Anonymous Gregorian algorithm, verified against known dates 2020–2030 |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/antonysastre/salario.
