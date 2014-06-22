require 'thor'
require 'fileutils'
require 'erb'

module Infrataster
  class CLI < Thor
    desc "init", "Initialize Infrataster specs."
    option :path, type: :string, default: '.'
    def init
      path = File.expand_path(options[:path])
      FileUtils.mkdir_p(path)
      create_file_from_template(File.expand_path("Gemfile", path))
      create_file_from_template(File.expand_path("Rakefile", path))
      FileUtils.mkdir(File.expand_path("spec", path))
      if ask_yes_or_no("Use Vagrant?")
        create_file_from_template(File.expand_path("spec/Vagrantfile", path))
      end
      create_file_from_template(File.expand_path("spec/spec_helper.rb", path))
      create_file_from_template(File.expand_path("spec/app_spec.rb", path))
    end

    private
    def ask_yes_or_no(question)
      print "#{question} (y/N): "
      answer = $stdin.gets
      if answer =~ /^y/i
        true
      else
        false
      end
    end

    def create_file_from_template(path)
      basename = File.basename(path)

      if File.exist?(path)
        puts "#{basename} exists already. Skip."
        return
      end

      open(path, 'w') do |f|
        f.write(ERB.new(File.read(File.expand_path("../fixtures/#{basename}.erb", __FILE__))).result)
      end

      puts "Created: #{basename}"
    end
  end
end
