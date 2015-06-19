FactoryGirl.define do
  factory :match do
    date "2014-06-26 11:00:00"
    home_team true
    opponent "paxton"
    location "paxton"
    comment "let's beat them"

    factory :match_in_past do
      date "2012-06-12 11:00:00"
    end
  end
end
