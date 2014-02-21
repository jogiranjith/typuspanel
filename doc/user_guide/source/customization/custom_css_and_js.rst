Custom CSS and Javascript
=========================

To override styles defined by Typus, create a file named ``app/assets/stylesheets/typus/custom.css``.
Place your custom CSS into that file. Likewise, to load custom Javascript, create ``app/assets/javascripts/typus/custom.js``.

Most likely, you will need to create the folders ``app/assets/stylesheets/typus`` and ``app/assets/javascripts/typus`` first.

(Don't forget to do ``rake assets:precompile`` if you are in a production environment.)
