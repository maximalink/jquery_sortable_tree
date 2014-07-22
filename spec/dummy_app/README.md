## JquerySortableTree Test Application

#### Ruby 2.0.0p247 + Rails 4 + Haml 4 + jquery_sortable_tree (2.5.0)


### Install App and try to use JquerySortableTree

Create Database config file

```
cp config/database.yml.example config/database.yml
```

Create Database and Test data

```
rake db:bootstrap_and_seed
```

Start Rails 4

```
rails s
```

or

```
rails s -p 3000 -b site.com
```

Open browser

```
localhost:3000
```

### How to run tests for JquerySortable tree

```ruby
git clone git@github.com:maximalink/jquery_sortable_tree.git
cd jquery_sortable_tree/spec/dummy_app/

# cp config/database.yml.example config/database.yml

rake db:bootstrap RAILS_ENV=test
rspec
```
