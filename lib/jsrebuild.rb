require 'time'

require 'coolio'
require 'eventful'
require 'jake'

module JSRebuild
  VERSION     = "0.1.0"
  
  CONFIG_FILE = Jake::CONFIG_FILE
  HELPER_FILE = Jake::HELPER_FILE
  
  LOG_FORMAT  = "%-020s %-10s %-040s %-07s"
  
  require 'jsrebuild/config'
  require 'jsrebuild/watcher'
  require 'jsrebuild/runner'
end
