# Typus: Admin Panel for Ruby on Rails applications

**Typus** is a control panel for [Ruby on Rails][rails] applications to
allow trusted users edit structured content.

It's not a CMS with a full working system but it provides a part of the
system: authentication, permissions and basic look and feel for your
websites control panel. So using [Rails][rails] with **Typus** lets you
concentrate on your application instead of the bits to manage the system.

**Typus** is the "old latin" word for **type** which stands for:

> A category of people or things having common characteristics.

![Main View](http://cloud.github.com/downloads/fesplugas/typus/001-typus.png)

You can try a demo [here][typus_demo].


## Key Features

- Built-in Authentication and Access Control Lists.
- CRUD and custom actions for your models on a clean interface.
- Internationalized interface ([See available translations][typus_locales])
- Customizable and extensible templates.
- Integrated [paperclip][paperclip] and [dragonfly][dragonfly] attachments viewer.
- Supports Rails 4.0 and 3.2.


## Installing

Add **Typus** to your `Gemfile`.

If you are using **Rails 4.0**, you can use `master` or `4-0-stable` branch:

    gem "typus", :git => "git://github.com/fesplugas/typus.git"
    gem "typus", :git => "git://github.com/fesplugas/typus.git", :branch => "4-0-stable"

If you are using **Rails 3.2**:

    gem "typus", :git => "git://github.com/fesplugas/typus.git", :branch => "3-2-stable"

Update your bundle, run the generator and start the application server:

    $ bundle install
    $ rails generate typus
    $ rails server

and go to <http://0.0.0.0:3000/admin>.


## Testing

[![Build Status](https://travis-ci.org/fesplugas/typus.png?branch=master)](https://travis-ci.org/fesplugas/typus)

To test, clone the repo and run:

    $ git clone --recursive git://github.com/fesplugas/typus.git
    $ bundle install --path vendor/bundle
    $ bundle exec rake


## Submitting an Issue

We use the [GitHub issue tracker][issues] to track bugs and features.
Before submitting a bug report or feature request, check to make sure it
hasn't already been submitted. You can indicate support for an existing
issue by voting it up. When submitting a bug report, please include a
[Gist][gist] that includes a stack trace and any details that may be
necessary to reproduce the bug, including your gem version, Ruby
version, and operating system. Ideally, a bug report should include a
pull request with failing specs.


## Links

- [Documentation](http://docs.typuscmf.com/)
- [RubyGems][typus_gem]
- [Contributors List](http://github.com/fesplugas/typus/contributors)


## License

**Typus** is released under the MIT license.

[typus]: http://github.com/fesplugas/typus
[typus_demo]: http://demo.typuscmf.com/
[typus_locales]: https://github.com/fesplugas/typus/tree/master/config/locales
[typus_gem]: http://rubygems.org/gems/typus
[paperclip]: http://rubygems.org/gems/paperclip
[dragonfly]: http://rubygems.org/gems/dragonfly
[rails]: http://rubyonrails.org/
[gist]: https://gist.github.com/
[issues]: https://github.com/fesplugas/typus/issues
[kaminari]: http://rubygems.org/gems/kaminari
[will_paginate]: http://rubygems.org/gems/will_paginate
