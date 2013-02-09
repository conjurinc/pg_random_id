# PgRandomId

Allow usage of pseudo-random IDs in Postgresql databases.
Changes sequential surrogate ids (1, 2, 3...) into a pseudo-random
sequence of unique 30-bits nonnegative integer values (eg. 760280231, 110168588, 1029278017...)
or 6-character human-friendly-ish strings (eg. kn5xx1, qy2kp8, e5f67z...).

Since surrogate IDs are often used in REST-ful URLs, this makes the addresses less revealing and harder to guess
(while preserving the straightforward mapping from URLs to database IDs):
- http://example.com/products/1 → http://example.com/products/134178313
- http://example.com/products/2 → http://example.com/products/121521131
- http://example.com/foo/1 → http://example.com/foo/2agc30
- http://example.com/foo/2 → http://example.com/foo/4zkabg


Although the code is 100% database-side, it has been packaged into Ruby functions plugging 
into ActiveRecord and Sequel migrations for ease of use.

## Installation

Add this line to your application's Gemfile:

    gem 'pg_random_id'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pg_random_id

## Synopsis

### ActiveRecord

```ruby
class InstallRandomId < ActiveRecord::Migration
  def up
    # install the necessary SQL functions in the DB
    create_random_id_functions
  end
end

class CreateProducts < ActiveRecord::Migration
  def up
    create_table :products do |t|
      t.string :name
    end
    
    # make the table use random ids
    random_id :products
  end
end

class RandomizeIdsOnFoo < ActiveRecord::Migration
  def up
    # make ids on a previously created table 
    # 'foo' random (using string ids)
    random_str_id :foo, :foo_id # you can specify id column name
  end
end
```

### Sequel

```ruby
Sequel.migration do
  up do
    # install the necessary SQL functions in the DB
    create_random_id_functions
  end
end

Sequel.migration do
  up do
    create_table :products do
      primary_key :id
      String :name
    end
    
    # make the table use random ids
    random_id :products
  end
end

Sequel.migration do
  up do
    # make ids on a previously created table 
    # 'foo' random (using string ids)
    random_str_id :foo, :foo_id # you can specify id column name
  end
end
```

## Notes

No model modification is necessary, just use the table as usual and it will simply work.
Each table will use its own unique sequence, chosen at random at migration time.
If you use `random_str_id` make sure to use the correct type (ie. char(6)) in 
foreign key columns.

The `random_id` function changes the default value of the ID column to a scrambled next sequence value.
The scrambling function is a simple Feistel network, with a variable parameter which is used to choose the sequence.

With `random_str_id` function, the column type is changed to character(6)
and the sequence is additionally base32-encoded 
with [Crockford encoding](http://www.crockford.com/wrmg/base32.html).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
