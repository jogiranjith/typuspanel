Adding a Rich Text Editor
=========================

Include the ``rails-ckeditor`` gem in your ``Gemfile``:

.. code-block:: ruby

  gem "rails-ckeditor"

Once added update your bundle:

.. code-block:: bash

  bundle install

On you application configuration files (`config/typus`) you can now enable this
new template where needed. Eg.

.. code-block:: yaml

  Post:
    fields:
      default: title
      form: title, content
      options:
        templates:
          content: text_with_ckeditor

.. note::

   CKEditor is only available for Typus 3.2 or higher.
