# Hydra::Works

[![Version](https://badge.fury.io/rb/hydra-works.png)](http://badge.fury.io/rb/hydra-works)
[![Build Status](https://travis-ci.org/projecthydra-labs/hydra-works.svg?branch=master)](https://travis-ci.org/projecthydra-labs/hydra-works)
[![Coverage Status](https://coveralls.io/repos/projecthydra-labs/hydra-works/badge.svg?branch=master)](https://coveralls.io/r/projecthydra-labs/hydra-works?branch=master)
[![Code Climate](https://codeclimate.com/github/projecthydra-labs/hydra-works/badges/gpa.svg)](https://codeclimate.com/github/projecthydra-labs/hydra-works)
[![Apache 2.0 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE)
[![Contribution Guidelines](http://img.shields.io/badge/CONTRIBUTING-Guidelines-blue.svg)](./CONTRIBUTING.md)
[![API Docs](http://img.shields.io/badge/API-docs-blue.svg)](http://rubydoc.info/gems/hydra-works)
[![Stories in Ready](https://badge.waffle.io/projecthydra-labs/hydra-works.png?source=projecthydra-labs%2Fhydra-works&label=ready&title=Ready)](https://waffle.io/projecthydra-labs/hydra-works?source=projecthydra-labs%2Fhydra-works)

The Hydra::Works gem provides a set of [Portland Common Data Model](https://github.com/duraspace/pcdm/wiki)-compliant ActiveFedora models and associated behaviors around the broad concept of multi-file "works", the need for which was expressed by a variety of [community use cases](https://github.com/projecthydra-labs/hydra-works/tree/master/use-cases). The Hydra::Works domain model includes:

 * **FileSet**: a *Hydra::PCDM::Object* that encapsulates one or more directly related *Hydra::PCDM::File*s, such as a PDF document, its derivatives, and extracted full-text
 * **GenericWork**: a *Hydra::PCDM::Object* that holds zero or more **FileSets**s and zero or more **Work**s (often you won't use GenericWork, but instead write your own Work class)
 * **Collection**: a *Hydra::PCDM::Collection* that indirectly contains zero or more **Work**s and zero or more **Collection**s

View [a diagram of the domain model](https://docs.google.com/drawings/d/1-NkkRPpGpZGoTimEpYTaGM1uUPRaT0SamuWDITvtG_8/edit).

Checkout the readme for [hydra-derivatives](https://github.com/projecthydra/hydra-derivatives#dependencies) for additional dependencies.

## Installation

Add these lines to your application's Gemfile:

    gem 'hydra-works', '~> 0.1'

And then execute:

    $ bundle install

Or install it yourself:

    $ gem install hydra-works

## Usage

Usage involves extending the behavior provided by this gem. In your application, you can create Hydra::Works-based models like so:

```ruby
class Collection < ActiveFedora::Base
  include Hydra::Works::CollectionBehavior
end

class Book < ActiveFedora::Base
  include Hydra::Works::WorkBehavior
end

class Page < ActiveFedora::Base
  include Hydra::Works::FileSetBehavior
end

collection = Collection.create
book = BookWork.create
page = Page.create

collection.works << book
collection.save
book.generic_files << page
book.save

file = page.files.build
file.content = "The quick brown fox jumped over the lazy dog."
page.save
```

## Virus Detection

To turn on virus detection, install clamav on your system and add the `clamav` gem to your Gemfile

    gem 'clamav'

Then include the `VirusCheck` module in your `FileSet` class:

```ruby
class BookFiles < ActiveFedora::Base
  include Hydra::Works::FileSetBehavior
  include Hydra::Works::VirusCheck
end
```

## Access controls

We are using [Web ACL](http://www.w3.org/wiki/WebAccessControl) as implemented by [hydra-access-controls](https://github.com/projecthydra/hydra-head/tree/master/hydra-access-controls).

## How to contribute

If you'd like to contribute to this effort, please check out the [contributing guidelines](CONTRIBUTING.md)

## Development

To set up for running the test suite, you need a copy of jetty

    $ rake jetty:clean
    $ rake jetty:config

To run the test suite, generate the test app (which goes into spec/internal) and start jetty (if it's not already running)

    $ rails engine_cart:generate
    $ rake jetty:start
    $ rake spec
