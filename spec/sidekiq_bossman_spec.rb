require 'rspec'
require File.expand_path(File.dirname(__FILE__) + "/../lib/sidekiq-bossman")

describe Sidekiq::Bossman do

  before do
    @sidekiq_bossman = Sidekiq::Bossman.new(File.expand_path(File.dirname(__FILE__) + "/sidekiq_project"),
                                            :require => "#{File.expand_path(File.dirname(__FILE__) + "/sidekiq_project")}/boot.rb",
                                            :environment => "test",
                                            :daemon => true)
  end

  after do
    begin
      Process.kill("TERM", File.read(@sidekiq_bossman.pidfile).to_i)
    rescue
    end
  end

  context ".start" do

    it 'successfully starts the Sidekiq workers' do
      begin
        fork { @sidekiq_bossman.start_workers }
        sleep 2
      ensure
        File.exists?(@sidekiq_bossman.pidfile).should be_true
      end
    end

  end

  context ".stop" do

    it 'successfully stops the Sidekiq workers' do
      begin
        fork { @sidekiq_bossman.start_workers }
        sleep 2
        @sidekiq_bossman.stop_workers
      ensure
        File.exists?(@sidekiq_bossman.pidfile).should be_false
      end
    end

  end

end