
Factory.define :user do |user|
  user.name "Arun V"
  user.email "arun.vydianathan@gmail.com"
  user.password "foobar"
  user.password_confirmation "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end
