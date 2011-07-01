namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "root",
                         :email => "alexey@home.org",
                         :password => "123456",
                         :password_confirmation => "123456")
    admin.toggle!(:admin)
    admin.toggle!(:manager)
    manager = User.create!(:name => "manager",
                         :email => "elena@home.org",
                         :password => "123456",
                         :password_confirmation => "123456")
    manager.toggle!(:manager)
    49.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(:name => name,
                   :email => email,
                   :manager => false,
                   :password => password,
                   :password_confirmation => password)
    end
  end
end
