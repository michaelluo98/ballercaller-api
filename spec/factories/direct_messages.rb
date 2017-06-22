FactoryGirl.define do
  factory :direct_message do
    message "MyText"
    sender nil
    recipient nil
  end
end
