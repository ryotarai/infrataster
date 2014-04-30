require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "open-uri"

def yellow(str)
  "\e[33m#{str}\e[m"
end

ENV['VAGRANT_CWD'] = File.expand_path('spec/integration/vm')

namespace :spec do
  RSpec::Core::RakeTask.new("unit") do |task|
    task.pattern = "./spec/unit{,/*/**}/*_spec.rb"
  end

  RSpec::Core::RakeTask.new("integration") do |task|
    task.pattern = "./spec/integration{,/*/**}/*_spec.rb"
  end

  namespace :integration do
    integration_dir = 'spec/integration'

    task :prepare => ['download_browsermob', 'start_vm'] do
    end

    task :download_browsermob do
      dir = File.join(integration_dir, 'vm/vendor/browsermob')
      unless Dir.exist?(dir)
        puts yellow("Downloading browsermob...")
        Dir.mktmpdir do |tmp|
          Dir.chdir(tmp) do
            system("wget -O browsermob-proxy.zip https://s3-us-west-1.amazonaws.com/lightbody-bmp/browsermob-proxy-2.0-beta-9-bin.zip")
            system "unzip browsermob-proxy.zip"
          end
          FileUtils.mv(File.join(tmp, 'browsermob-proxy-2.0-beta-9'), dir)
        end
      end
    end

    task :berks_vendor do
      dir = File.join(integration_dir, 'vm/vendor/cookbooks')
      # Berkshelf
      if Dir.exist?(dir)
        puts yellow("'#{dir}' already exists. If you want update cookbooks, delete the directory and re-run rake command")
      else
        puts yellow('Installing cookbooks by berkshelf...')
        system "cd #{integration_dir}/vm && berks vendor vendor/cookbooks"
      end
    end

    task :start_vm => ['berks_vendor'] do
      puts yellow('Starting VM...')
      system '/usr/bin/vagrant up'
    end
  end
end

