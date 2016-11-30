# Hydra::Works

[![Version](https://badge.fury.io/rb/hydra-works.png)](http://badge.fury.io/rb/hydra-works)
[![Build Status](https://travis-ci.org/projecthydra/hydra-works.svg?branch=master)](https://travis-ci.org/projecthydra/hydra-works)
[![Coverage Status](https://coveralls.io/repos/projecthydra/hydra-works/badge.svg?branch=master)](https://coveralls.io/r/projecthydra/hydra-works?branch=master)
[![Code Climate](https://codeclimate.com/github/projecthydra/hydra-works/badges/gpa.svg)](https://codeclimate.com/github/projecthydra/hydra-works)
[![Apache 2.0 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE)
[![Contribution Guidelines](http://img.shields.io/badge/CONTRIBUTING-Guidelines-blue.svg)](./CONTRIBUTING.md)
[![API Docs](http://img.shields.io/badge/API-docs-blue.svg)](http://rubydoc.info/gems/hydra-works)

The Hydra::Works gem implements the [PCDM](https://github.com/duraspace/pcdm/wiki) [Works](https://github.com/duraspace/pcdm/blob/master/pcdm-ext/works.rdf) data model using ActiveFedora-based models. In addition to the models, Hydra::Works includes associated behaviors around the broad concept of describable "works" or intellectual entities, the need for which was expressed by a variety of [Hydra community use cases](https://github.com/projecthydra/hydra-works/tree/master/use-cases). The PCDM Works domain model includes the following high-level entities:

 * **Collection**: a *pcdm:Collection* that indirectly contains zero or more **Works** and zero or more **Collection**s
 * **Work**: a *pcdm:Object* that holds zero or more **FileSets** and zero or more **Works**
 * **FileSet**: a *pcdm:Object* that groups one or more related *pcdm:Files*, such as an original file (e.g., PDF document), its derivatives (e.g., a thumbnail), and extracted full-text

View [a diagram of the Hydra::Works domain model](https://docs.google.com/drawings/d/1if47TYgEhqDLPh3D0026B_cBLa0BEAOpWPs8AqoQMZE/edit).

Behaviors included in the model include:

 * Characterization of original files within FileSets
 * Generation of derivatives from original files
 * Virus checking of original files
 * Full-text extraction from original files

Check out the [Hydra::Derivatives README](https://github.com/projecthydra/hydra-derivatives#dependencies) for additional dependencies.

## Installation

Add these lines to your application's Gemfile:

    gem 'hydra-works', '~> 0.15'

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
book = Book.create
page = Page.create

collection.members << book
collection.save

book.members << page
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
class Page < ActiveFedora::Base
  include Hydra::Works::FileSetBehavior
  include Hydra::Works::VirusCheck
end
```

## Access controls

We are using [Web ACL](http://www.w3.org/wiki/WebAccessControl) as implemented by [hydra-access-controls](https://github.com/projecthydra/hydra-head/tree/master/hydra-access-controls).

## How to contribute

If you'd like to contribute to this effort, please check out the [contributing guidelines](CONTRIBUTING.md)

## Development

### Testing with the continuous integration server

You can test Hydra::Works using the same process as our continuous
integration server. To do that, run the default rake task which will download Solr and Fedora, start them,
and run the tests for you.

```bash
rake
```

### Testing manually

If you want to run the tests manually, follow these instructions:

```bash
solr_wrapper -d solr/config/
```

To start FCRepo, open another shell and run:

```bash
fcrepo_wrapper -p 8984
```

Now you’re ready to run the tests. In the directory where hydra-works
is installed, run:

```bash
rake spec
```
