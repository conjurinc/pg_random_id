# PgRandomId

Allow usage of pseudo-random IDs in Postgresql databases.
Changes sequential surrogate ids (1, 2, 3...) into a pseudo-random
sequence of unique 30-bits nonnegative integer values (eg. 760280231, 110168588, 1029278017...).

Integrates with ActiveRecord. Sequel integration is upcoming.

## Installation

Add this line to your application's Gemfile:

    gem 'pg_random_id'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pg_random_id

## Usage

The easiest way to use it is to use the supplied migration functions.

First, make sure you put
    create_random_id_functions
in a migration (a single one will do).

Then to apply random ids to a table, use random_id function:

```ruby
class RandomizeIdsOnFoo < ActiveRecord::Migration
  def up
    KEY = 21315
    random_id :foo, :foo_id, KEY
  end
end
```

If you don't supply the key, a random one will be generated;
similarly, the id column name defaults to :id. 
This means that you can create a vanilla AR table with random ids
with the following simple migration:

```ruby
class CreateProducts < ActiveRecord::Migration
  def up
    create_table :products do |t|
      t.string :name
    end
    random_id :products
  end
end
```

No model modification is necessary, just use the table as usual and it will simply work.
You can even use it without ActiveRecord.

### Text ids

If you use random_str_id function instead, it will additionally 
change the column type to character(6) and store the ids as base32-encoded
strings of handy human-friendly form (eg. kn5xx1, qy2kp8, e5f67z...).

Remember to use the correct type for any foreign key columns in other tables 
if you use this.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
