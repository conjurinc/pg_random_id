# PgRandomId

Allow usage of pseudo-random IDs in Postgresql databases.
Changes sequential surrogate ids (1, 2, 3...) into a pseudo-random
sequence of unique 30-bits nonnegative integer values.

Integrates with ActiveRecord.

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
