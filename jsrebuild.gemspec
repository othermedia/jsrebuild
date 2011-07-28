Gem::Specification.new do |s|
  s.name        = "jsrebuild"
  s.version     = "0.1.0"
  
  s.author      = "Benedict Eastaugh"
  s.email       = "benedict@eastaugh.net"
  s.homepage    = "https://github.com/othermedia/jsrebuild"
  
  s.summary     = "Dynamic rebuilder for JavaScript projects"
  s.description = "Dynamically runs the Jake build tool to rebuild JavaScript
                   projects in development environments.".sub(/\s+/, " ")
  
  s.license     = "BSD"
  
  s.add_dependency "cool.io",  ">= 1.0.0"
  s.add_dependency "eventful", ">= 1.0.0"
  s.add_dependency "jake",     ">= 1.0.1"
  
  s.executables = ["jsrebuild"]
  
  s.files       = %w(History.txt LICENCE README.md) +
                  Dir.glob("{bin,lib}/**/*")
  
  s.test_file   = "test/test_jsrebuild.rb"
end
