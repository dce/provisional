# rails new_app_name -m viget.rb

# freeze rails
rake 'rails:freeze:gems'

# install gems
gem 'mocha', :version => '>= 0.9.5'
gem 'thoughtbot-factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com', :version => '>= 1.2.0'
gem 'thoughtbot-shoulda', :lib => 'shoulda', :source => 'http://gems.github.com', :version => '>= 2.10.1'
rake 'gems:install gems:unpack'

# install plugins
plugin 'hoptoad_notifier', :git => 'git://github.com/thoughtbot/hoptoad_notifier.git'
plugin 'jrails', :git => 'git://github.com/aaronchi/jrails.git'
plugin 'model_generator_with_factories', :git => 'git://github.com/vigetlabs/model_generator_with_factories.git'
plugin 'viget_deployment', :git => 'git://github.com/vigetlabs/viget_deployment.git'
plugin 'vl_cruise_control', :git => 'git://github.com/vigetlabs/vl_cruise_control.git'
plugin 'asset_packager', :git => 'git://github.com/sbecker/asset_packager.git'

# generate viget_deployment stuff
generate :viget_deployment

# clean up
run 'rm -rf public/images/rails.png log/* test/fixtures'
inside 'public' do
  run 'rm -f index.html favicon.ico robots.txt'
end
inside 'public/javascripts' do
  run 'rm -f dragdrop.js controls.js effects.js prototype.js'
end

# Copy database.yml for distribution use
run 'cp config/database.yml config/database.yml.example'

# Set up .gitignore files
file '.gitignore', %q[
.DS_Store
coverage/*
log/*.log
db/*.db
db/*.sqlite3
tmp/**/*
config/database.yml
END
run 'touch tmp/.gitignore log/.gitignore vendor/.gitignore'
]

# install jrails javascripts
rake 'jrails:install:javascripts'

# setup shoulda rake tasks
file 'lib/tasks/shoulda.rake', %q[require 'shoulda/tasks']
