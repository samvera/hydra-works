# Hydra::Works
[![Build Status](https://travis-ci.org/projecthydra-labs/hydra-works.svg?branch=master)](https://travis-ci.org/projecthydra-labs/hydra-works)
[![Coverage Status](https://coveralls.io/repos/projecthydra-labs/hydra-works/badge.svg?branch=master)](https://coveralls.io/r/projecthydra-labs/hydra-works?branch=master)

Hydra implementation of a works model based on the [Portland Common Data Model](https://github.com/projecthydra-labs/hydra-pcdm) (PCDM).


## Installation

Add these lines to your application's Gemfile:

```ruby
  gem 'active-fedora', github: 'projecthydra/active_fedora' # hydra-pcdm requires an unreleased version of ActiveFedora
  gem 'hydra-pcdm', github: 'projecthydra-labs/hydra-pcdm'
  gem 'hydra-works', github: 'projecthydra-labs/hydra-works'
```

Substitute another branch name for 'master' to test out a branch under development.    
<!-- Temporarily comment out until gem is published.
    gem 'hydra-pcdm' 
-->

And then execute:
```
    $ bundle
```
<!-- Temporarily comment out until gem is published.
Or install it yourself as:

    $ gem install hydra-works
-->

## Access Controls
We are using [Web ACL](http://www.w3.org/wiki/WebAccessControl) as implemented by [hydra-access](https://github.com/projecthydra/hydra-head/tree/master/hydra-access-controls) controls

## Hydra Works Model

PCDM Reference:  [Portland Common Data Model](https://wiki.duraspace.org/x/9IoOB)

![Hydra Works Model Definition](https://docs.google.com/presentation/d/1d43d5o2d0x6NyI1tjjuJN6BDI9F9XYxZ1_9_EoZbAyE/edit#slide=id.p8)


## Usage

Hydra-works provides three classes:
```
Hydra::Works::Collection - a collection aggregates collections and generic works
Hydra::Works::GenericWork - a generic work aggregates generic works and generic files
Hydra::Works::GenericFile - a generic file aggregates generic files and contains pcdm files
```

A `Hydra::PCDM::File` is a NonRDFSource &emdash; a bitstream.  You can use this to store content. A PCDM::File is contained by a PCDM::Object. A `File` has some attached technical metadata, but no descriptive metadata.  A `Hydra::PCDM::Object` contains files and other objects and may have descriptive metadata.  A `Hydra::PCDM::Collection` can contain other `Collection`s or `Object`s but not `File`s.  A `Collection` also may have descriptive metadata.

Typically usage involves extending the behavior provided by this gem. In your application you can write something like this:

```ruby

class Collection < ActiveFedora::Base
  include Hydra::PCDM::CollectionBehavior
  include Hydra::Works::CollectionBehavior
end

class BookWork < ActiveFedora::Base
  include Hydra::PCDM::ObjectBehavior
  include Hydra::Works::GenericWorkBehavior
end

class BookFiles < ActiveFedora::Base
  include Hydra::PCDM::ObjectBehavior
  include Hydra::Works::GenericFileBehavior
end


c1 = Collection.create
bw1 = BookWork.create
bf1 = BookFiles.create

bf1.save
bw1.generic_files = [bf1]
bw1.save
c1.generic_works = [bw1]
# c1.members << b1 # This should work in the future
c1.save


# This section waiting on https://github.com/projecthydra-labs/hydra-pcdm/pull/52
# f1 = b1.files.build
# f1.conent = "The quick brown fox jumped over the lazy dog."
# b1.save
```

## How to contribute
If you'd like to contribute to this effort, please check out the [Contributing Guide](CONTRIBUTING.md)
