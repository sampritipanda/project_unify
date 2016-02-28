FactoryGirl.define do
  factory :authentication_token do
    body "MyString"
    user nil
    last_used_at "2016-02-27 16:41:06"
    ip_address "MyString"
    user_agent "MyString"
  end
end
