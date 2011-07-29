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
  s.add_dependency "oyster",   ">= 0.9.5"
  
  s.executables = ["jsrebuild"]
  
  s.files       = Dir.glob("{bin,lib}/**/*") +
                  %w(History.txt LICENSE README.md)
end
