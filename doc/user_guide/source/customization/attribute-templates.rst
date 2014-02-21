Attribute Templates
===================

It is possible to change the presentation for an attribute within the form.
In the example below the ``published_at`` attribute is datetime attribute
and will use the ``_datetime.html.erb`` template located on the templates
folder ``app/views/admin/templates``.

.. code-block:: erb

  # app/views/admin/templates/_datetime.html.erb
  <li id="<%= attribute_id %>">
    <%= form.label attribute, label_text %>
    <%= form.calendar_date_select attribute %>
  </li>

You can also create your own template and define which attributes will use it.
Let's say for example you define a ``_rich_text_with_fcke.html.erb`` template
on your templates folder. You can enable the usage of that template like in the
following example:

.. code-block:: yaml

  Entry:
    fields:
      default: title
      form: body
      options:
        templates:
          body: rich_text_with_fcke

I recommend using `Typus Templates`_ as an starting point create you own.

.. _Typus Templates: https://github.com/fesplugas/typus/tree/master/app/views/admin/templates
