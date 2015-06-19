FactoryGirl.define do
  factory :user do
    first_name            'John'
    last_name             'Doe'
    email                 'john.doe@example.com'
    phone_number          '555-555-5555'
    password              'password'
    password_confirmation 'password'

    factory :user2 do
      first_name 'Dave'
      last_name  'Kroondyk'
      email      'dave.kroondyk@example.com'
    end

    factory :captain do
      first_name 'captain'
      last_name  'captain'
      email      'captain@example.com'
    end
  end
end

