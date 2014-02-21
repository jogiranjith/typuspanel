# To Run:
#
#     rails new typus-demo -m https://raw.github.com/fesplugas/typus/master/doc/template.rb
#     rails new typus-demo -m ~/Development/typus/doc/template.rb
#

# Generate some stuff
generate :model, 'Entry title:string'
rake 'db:migrate'

# Add Typus to Gemfile and run generator
gem 'typus', :git => 'git://github.com/fesplugas/typus.git'
run 'bundle install --quiet'
generate 'typus'
generate 'typus:migration'
rake 'db:migrate'

# Redirect root to admin
root :to => redirect('/admin')
