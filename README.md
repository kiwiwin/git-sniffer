# GitSniffer

GitSniffer is used for analysis git repository, one can check example for how to use this gem

## Installation

Add this line to your application's Gemfile:

    gem 'git_sniffer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git_sniffer

## Usage

### Git Repository

#### Open a git repository

To open a git repository, we need specify the .git directory, and it will return a GitSniffer::Base object

		base = GitSniffer::Base.open("xxx.git")

with base objects, you can get detail information about this repository, you can see examples for specification.	

### Lazy

because different commits may point to same blob or tree and also sometime we do not need all the objects to be calculated. Lazy solve this problem

include lazy in your class

		require 'lazy'
		class Dummy
			include Lazy
		end

you have two ways to use lazy:

1) add lazy source

		lazy_reader :val
		def lazy_val_source
			...result will be set as val...
		end

the lazy will find lazy_attr_source itself, so the name of the lazy source matters

2) use init

		lazy_reader :val1, :val2, :init => :init_fun
		def init_fun
			@val1 = ...
			@val2 = ...
		end

in this stituation, init_fun will be called only once to init val1 and val2. Notice that it is you duty to initialize @val1, @val2 inside the init_fun scope, you don't need name it as init_fun

### Hook

hook method is used to give Class extend functional. Inside the hook method, it use function provided by Lazy

Add a hook method:
	
	GitSniffer::Commit.add_hook(:committer) { |commit| commit.committer }

Use hook method result

	@commit.hook_committer

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
