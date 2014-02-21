Custom Authentication
=====================

Providing your own authentication is simple!

Change the Typus configuration to use your custom module:

.. code-block:: ruby

  # config/initializers/typus.rb
  Typus.setup do |config|
    config.authentication = :custom
  end

In this example the custom ``authenticate_admin_user!`` method
of the included ``UserHandling`` module takes care of the authentication:

.. code-block:: ruby

  # app/support/typus/authentication/custom.rb
  module Typus
    module Authentication
      module Custom
        protected
        include Base
        include UserHandling

        def authenticate
          @admin_user = FakeUser.new
          authenticate_admin_user!
        end
      end
    end
  end
