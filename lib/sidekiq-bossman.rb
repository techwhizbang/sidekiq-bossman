require 'rubygems'
require 'sidekiq/cli'

module Sidekiq
  class Bossman

    attr_accessor :config, :pidfile,
                  :logfile, :require,
                  :daemon, :timeout,
                  :verbose, :concurrency,
                  :queue, :environment


    ##
    # Takes the following options that currently match the version
    # of Sidekiq this gem depends upon:
    # :config, :pidfile, :logfile, :require, :timeout, :verbose, :queue,
    # :concurrency, :daemon
    def initialize(project_root, options = {})

      default_options = {:config => "#{project_root}/config/sidekiq.yml",
                         :pidfile => "#{project_root}/tmp/pids/sidekiq.pid",
                         :logfile => "#{project_root}/log/sidekiq.log",
                         :require => "#{project_root}",
                         :environment => "development",
                         :timeout => 10,
                         :verbose => false,
                         :queue => nil,
                         :concurrency => nil,
                         :daemon => true}
      options = default_options.merge(options)
      options.each { |k, v| send("#{k}=", v) }
    end

    def start_workers
      sidekiq = Sidekiq::CLI.instance

      args = []

      ["-r", @require].each { |arg| args << arg } unless @require.nil?
      ["-t", @timeout.to_s].each { |arg| args << arg } unless @timeout.nil?
      ["-L", @logfile].each { |arg| args << arg } unless @logfile.nil?
      ["-C", @config].each { |arg| args << arg } unless @config.nil?
      ["-P", @pidfile].each { |arg| args << arg } unless @pidfile.nil?
      ["-q", @queue].each { |arg| args << arg } unless @queue.nil?
      ["-c", @concurrency].each { |arg| args << arg } unless @concurrency.nil?
      ["-e", @environment].each { |arg| args << arg } unless @environment.nil?
      args << "-d" if @daemon == true
      args << "-v" if @verbose == true

      sidekiq.parse args

      sidekiq.run
    end

    def stop_workers
      system "if [ -f #{@pidfile} ]; then bundle exec sidekiqctl stop #{@pidfile}; fi"
    end

  end
end
