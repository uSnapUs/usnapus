if ENV['MY_RUBY_HOME'] && ENV['MY_RUBY_HOME'].include?('rvm')
  begin
    rvm_path     = File.dirname(File.dirname(ENV['MY_RUBY_HOME']))
    rvm_lib_path = File.join(rvm_path, 'lib')
    $LOAD_PATH.unshift rvm_lib_path
    require 'rvm'
    RVM.use_from_path! File.dirname(File.dirname(__FILE__))
  rescue LoadError
    # RVM is unavailable at this point.
    raise "RVM ruby lib is currently unavailable."
  end
end
 
ENV['BUNDLE_GEMFILE'] = File.expand_path('../Gemfile', File.dirname(__FILE__))
require '/usr/local/rvm/gems/ruby-1.9.2-p290/gems/bundler-1.0.22/lib/bundler/setup'