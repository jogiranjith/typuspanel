Devise Authentication
=====================

Add **Typus** and **Devise** to your ``Gemfile``:

.. code-block:: ruby

  gem "devise", "~> 2.0.4"
  gem "typus", "~> 3.1.9"

Generate **Devise** required stuff:

.. code-block:: bash

  rails generate devise:install
  rails generate devise DeviseUser
  rake db:migrate

Run the **Typus** generator:

.. code-block:: bash

  rails generate typus

Configure the initializer:

.. code-block:: ruby

    # config/initializers/typus.rb
    Typus.setup do |config|
      config.authentication = :devise
    end

There are some changes you need to do to your ``DeviseUser``.

.. literalinclude:: ../../../../test/dummy/app/models/devise_user.rb
   :language: ruby
   :emphasize-lines: 1-2,14-15

Finally start your application and go to http://localhost:3000/admin, you should
be redirected to the sign in form provided by **Devise**.
