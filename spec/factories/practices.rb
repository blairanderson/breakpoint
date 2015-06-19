FactoryGirl.define do
  factory :practice do
    date "2014-06-23 11:00:00"
    location "paxtonclub"
    comment "at Waltham"

    factory :practice_in_past do
      date "2012-06-12 11:00:00"
    end
  end
end
