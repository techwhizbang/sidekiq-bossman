require 'rubygems'
require 'sidekiq/cli'

module Sidekiq
  class Bossman

    attr_accessor :config, :pidfile,
                  :logfile, :require,
                  :daemon, :timeout,
                  :verbose, :concurrency,
                  :queue


    ##
    # Takes the following options that currently match the version
    # of Sidekiq this gem depends upon:
    # :config, :pidfile, :logfile, :require, :timeout, :verbose, :queue,
    # :concurrency, :daemon
    def initialize(options = {})
      project_root = defined?(Rails) ? Rails.root.to_s : options[:require]

      default_options = {:config => "#{project_root}/config/sidekiq.yml",
                         :pidfile => "#{project_root}/tmp/pids/sidekiq.pid",
                         :logfile => "#{project_root}/log/sidekiq.log",
                         :require => "#{project_root}",
                         :timeout => 10,
                         :verbose => false,
                         :queue => nil,
                         :concurrency => nil,
                         :daemon => true}
      options = default_options.merge(options)
      options.each { |k, v| send("#{k}=", v) }
    end

    def start
      sidekiq = Sidekiq::CLI.instance

      args = ["-C", @config,
              "-P", @pidfile,
              "-L", @logfile,
              "-t", @timeout,
              "-c", @concurrency,
              "-q", @queue,
              "-r", @require]

      args << "-d" if @daemon == true
      args << "-v" if @verbose == true

      sidekiq.parse args

      sidekiq.run
    end

    def stop
      system "if [ -f #{@pidfile} ]; then bundle exec sidekiqctl stop #{@pidfile}; fi"
    end

  end
end
