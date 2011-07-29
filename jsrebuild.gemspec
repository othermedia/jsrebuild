# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'jsrebuild'

Gem::Specification.new do |gem|
  gem.name         = "jsrebuild"
  gem.version      = JSRebuild::VERSION
  gem.platform     = Gem::Platform::RUBY
  
  gem.author       = "Benedict Eastaugh"
  gem.email        = "benedict@eastaugh.net"
  gem.homepage     = "https://github.com/othermedia/jsrebuild"
  
  gem.summary      = "Dynamic rebuilder for JavaScript projects"
  gem.description  = "Dynamically runs the Jake build tool to rebuild JavaScript
                      projects in development environmentgem.".sub(/\s+/, " ")
  
  gem.license      = "BSD"
  
  gem.add_dependency "cool.io",  ">= 1.0.0"
  gem.add_dependency "eventful", ">= 1.0.0"
  gem.add_dependency "jake",     ">= 1.0.1"
  gem.add_dependency "oyster",   ">= 0.9.5"
  
  gem.executables  = ['jsrebuild']
  gem.require_path = 'lib'
  gem.files        = Dir.glob("{bin,lib}/**/*") +
                     %w(History.txt LICENSE README.md)
end
