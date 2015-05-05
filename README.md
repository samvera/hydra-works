# Hydra::Works
[![Build Status](https://travis-ci.org/projecthydra-labs/hydra-works.svg?branch=master)](https://travis-ci.org/projecthydra-labs/hydra-works)
[![Coverage Status](https://coveralls.io/repos/projecthydra-labs/hydra-works/badge.svg?branch=master)](https://coveralls.io/r/projecthydra-labs/hydra-works?branch=master)

The Hydra::Works gem provides a set of [Portland Common Data Model](https://wiki.duraspace.org/display/FF/Portland+Common+Data+Model)-compliant models and associated behaviors around the broad concept of multi-file "works", the need for which was expressed by a variety of [community use cases](https://github.com/projecthydra-labs/hydra-works/tree/master/use-cases). The Hydra::Works domain model includes:

 * **GenericFile**: a *pcdm:Object* that encapsulates one or more directly related *pcdm:File*s, such as a PDF document, its derivatives, and extracted full-text
 * **GenericWork**: a *pcdm:Object* that holds zero or more **GenericFile**s and zero or more **GenericWork**s
 * **Collection**: a *pcdm:Collection* that indirectly contains zero or more **GenericWork**s and zero or more **Collection**s

View [a diagram of the domain model](https://docs.google.com/drawings/d/1-NkkRPpGpZGoTimEpYTaGM1uUPRaT0SamuWDITvtG_8/edit).

## Installation

Add these lines to your application's Gemfile:

    gem 'hydra-works'

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

class BookWork < ActiveFedora::Base
  include Hydra::Works::GenericWorkBehavior
end

class BookFiles < ActiveFedora::Base
  include Hydra::Works::GenericFileBehavior
end

c1 = Collection.create
bw1 = BookWork.create
bf1 = BookFiles.create

bf1.save
bw1.generic_files = [bf1]
bw1.save
c1.generic_works = [bw1]
c1.save

f1 = bf1.files.build
f1.content = "The quick brown fox jumped over the lazy dog."
bf1.save
```

## Access controls

We are using [Web ACL](http://www.w3.org/wiki/WebAccessControl) as implemented by [hydra-access-controls](https://github.com/projecthydra/hydra-head/tree/master/hydra-access-controls).

## How to contribute

If you'd like to contribute to this effort, please check out the [Contributing Guide](CONTRIBUTING.md)

## Development

To set up for running the test suite, you need a copy of jetty

    $ rake jetty:clean

To run the test suite, generate the test app (which goes into spec/internal) and start jetty (if it's not already running)

    $ rails engine_cart:generate
    $ rake jetty:start
    $ rake spec
