require File.join(File.dirname(__FILE__), 'parallel_tests')

class ParallelSpecs < ParallelTests
  def self.run_tests(test_files, process_number, options)
    cmd = "#{color} #{executable} #{options} #{spec_opts} #{test_files*' '}"
    execute_command(cmd, process_number)[:stdout]
  end

  def self.executable
    %w(spec rspec).each do |cmd|
      executable = if bundler_enabled?
        "bundle exec #{cmd}"
      elsif File.file?("script/#{cmd}")
        "script/#{cmd}"
      else
        cmd
      end
      return executable if system("#{executable} --version")
    end
    raise "Can't find executables rspec or spec"
  end

  protected

  def self.spec_opts
    opts = ['spec/parallel_spec.opts', 'spec/spec.opts'].detect{|f| File.file?(f) }
    opts ? "-O #{opts}" : nil
  end

  #display color when we are in a terminal
  def self.color
    ($stdout.tty? ? 'RSPEC_COLOR=1 ; export RSPEC_COLOR ;' : '')
  end

  def self.test_suffix
    "_spec.rb"
  end
end
