# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :match_set do
    games_won 6
    games_lost 2
    ordinal 1
    match_lineup
  end
end
