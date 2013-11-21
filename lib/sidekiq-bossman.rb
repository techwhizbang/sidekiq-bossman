require 'rubygems'

module Sidekiq
  class Bossman

    attr_accessor :config, :pidfile,
                  :logfile, :require,
                  :timeout, :verbose, :concurrency,
                  :queue, :queues, :environment


    ##
    # Takes the following options that currently match the version
    # of Sidekiq this gem depends upon:
    # :config, :pidfile, :logfile, :require, :timeout, :verbose, :queue,
    # :concurrency
    def initialize(project_root, options = {})

      default_options = {:config => "#{project_root}/config/sidekiq.yml",
                         :pidfile => "#{project_root}/tmp/pids/sidekiq.pid",
                         :logfile => "#{project_root}/log/sidekiq.log",
                         :require => "#{project_root}",
                         :environment => "development",
                         :timeout => 10,
                         :verbose => false,
                         :queue => nil,
                         :queues => [],
                         :concurrency => nil}
      options = default_options.merge(options)
      options.each { |k, v| send("#{k}=", v) }
    end

    ##
    # Starts the workers as a daemon with either the default or given
    # options hash in the initializer
    def start_workers
      start_cmd = "nohup bundle exec sidekiq -e #{@environment} -t #{@timeout} -P #{@pidfile}"
      start_cmd << " -v" if @verbose == true
      start_cmd << " -r #{@require}" unless @require.nil?
      start_cmd << " -C #{@config}" unless @config.nil?
      start_cmd << " -q #{@queue}" unless @queue.nil?
      @queues.each { |queue| start_cmd << " -q #{queue}" }
      start_cmd << " -c #{@concurrency}" unless @concurrency.nil?
      start_cmd << " >> #{@logfile} 2>&1 &"
      system start_cmd
    end

    def stop_workers
      system "if [ -f #{@pidfile} ]; then bundle exec sidekiqctl stop #{@pidfile}; fi"
    end

  end
end
