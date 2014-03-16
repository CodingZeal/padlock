# Padlock

[![Build Status](https://travis-ci.org/CodingZeal/padlock.png?branch=master)](https://travis-ci.org/CodingZeal/padlock) [![Code Climate](https://codeclimate.com/github/CodingZeal/padlock.png)](https://codeclimate.com/github/CodingZeal/padlock)

Lock a content item for editing.

## Installation

Add this line to your application's Gemfile:

    gem 'padlock'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install padlock

Generate the padlocks table with the included Rails generator:

    $ rails generate padlock:install
    $ rake db:migrate

## Usage

#### User:

Padlock will associate every lock to a User object.  Therefore, you need
to specify the User type model:

    class User < ActiveRecord::Base
      acts_as_padlock_user
    end

Optionally set the foreign key:

    class User < ActiveRecord::Base
      acts_as_padlock_user foreign_key: "admin_id"
    end

Once activated a User object can have many lockable objects

#### Locking:

All lockable objects are associated to a padlock user.

    current_user.padlock(lockable)  # => Lock the object for editing by the current_user. Override an existing lock
    current_user.padlock!(lockable) # => Lock the object and raise an exception if lockable is already locked by another user

You can also pass in multiple lockable objects to a single user.

    current_user.padlock(lockable_1 [, lockable_2, ...])

Or check the status of a single object.

    current_user.locked?(lockable) # => true/false

For integration with the Timeout gem, you can touch a lockable object and extend the padlock's TTL.

    currrent_user.touch(lockable_1 [, lockable, ...])

Padlocks can also be administered through the global Padlock object

    Padlock.lock(current_user, lockable [, lockable, ...]) # => locks it to the user
    Padlock.locked?(lockable)                              # => true/false
    Padlock.unlock!(lockable_1 [, lockable_2, ...])        # => unlocks a group of objects
    Padlock.unlocked?(lockable)                            # => true/false

#### Lockable Objects:

Padlock assumes that all objects inherited from `ActiveRecord::Base` can be locked by a user record.

    lockable.locked?   # => true/false
    lockable.unlocked? # => true/false
    lockable.locked_by # => associated padlock user record
    lockable.lock_touched_at # => last time the padlock was updated
    lockable.unlock!   # => unsets the padlock

#### Stale Padlocks

Lockables that have been locked for extended periods of time, may need to be reset.  In this case you can detect stale locks and unset them.

    Padlock.unlock_stale # => unlocks all padlocks that have not been touched in the last 24 hours

#### Configuration and Initialization

You can customize certain configuration options by added an initializer (config/padlock.rb) or pre-boot configuration file:

    Padlock.config.timeout = 1.week         # => sets a new unlock stale timeout.  Default is 24 hours.
    Padlock.config.table_name = "..."       # => define the database table name for the padlocks.  Default is "padlocks"
    Padlock.config.user_foreign_key = "..." # => defines the foreign key relating to the User object.  Default is "user_id".
    Padlock.config.user_class_name = "..."  # => defines the user model class.  Default is "User".

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
