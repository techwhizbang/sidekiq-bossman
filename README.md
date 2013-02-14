# Sidekiq::Bossman

[![Build Status](https://travis-ci.org/techwhizbang/sidekiq-bossman.png)](https://travis-ci.org/techwhizbang/sidekiq-bossman)

The goal of Sidekiq::Bossman is to provide an easy programmatic approach
to starting and stopping Sidekiq workers. Everything in Sidekiq::Bossman
is nothing more than an idiomatic Ruby abstraction atop what already exists in Sidekiq.
I was compelled to write this abstraction because I have many projects that
have the following commands scattered about in Rake tasks, shell scripts, etc:

    system "nohup bundle exec sidekiq -e #{Rails.env} -C #{Rails.root}/config/sidekiq.yml -P #{Rails.root}/tmp/pids/sidekiq.pid >> #{Rails.root}/log/sidekiq.log 2>&1 &"
    system "if [ -f tmp/pids/sidekiq.pid ]; then bundle exec sidekiqctl stop tmp/pids/sidekiq.pid; fi"

While there is nothing wrong with these commands, it felt error prone and sloppy to be
copying and pasting this across new projects. Since it has become a pattern with some of my projects I find
it useful.

Thanks to Mike Perham for providing us such a great framework.

## Installation

Add this line to your application's Gemfile:

    gem 'sidekiq-bossman'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sidekiq-bossman

## Usage

Start your Sidekiq workers

    Sidekiq::Bossman.new(Rails.root.to_s).start_workers

Stop your Sidekiq workers

    Sidekiq::Bossman.new(Rails.root.to_s).stop_workers

When initializing Sidekiq::Bossman it can take an options Hash, these are the defaults:

    {:config => "#{project_root}/config/sidekiq.yml",
     :pidfile => "#{project_root}/tmp/pids/sidekiq.pid",
     :logfile => "#{project_root}/log/sidekiq.log",
     :require => "#{project_root}",
     :timeout => 10,
     :verbose => false,
     :queue => nil,
     :concurrency => nil,
     :daemon => true}


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
