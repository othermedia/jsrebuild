module JSRebuild
  
  class Config
    attr_reader :config_file
    attr_reader :helper_file
    
    def initialize(dir, options)
      @dir         = File.expand_path(dir)
      @helper      = Jake::Helper.new(options)
      @config_file = Jake.path(dir, CONFIG_FILE)
      @helper_file = Jake.path(dir, HELPER_FILE)
    end
    
    def source_directory
      Jake.path(@dir, @config[:source_directory] || '.')
    end
    
    alias :source_dir :source_directory
    
    def build_directory
      Jake.path(@dir, @config[:source_directory] || '.')
    end
    
    alias :build_dir :build_directory
    
    def source_files
      []
    end
    
    def load!
      unless File.file?(@config_file)
        puts "No config file found at #{config_path}"
        return
      end
      
      unless File.readable?(@config_file)
        puts "Config file #{config_path} could not be read"
        return
      end
      
      begin
        yaml    = File.read(@config_file)
        @config = Jake.symbolize_hash( YAML.load(::Jake.erb(yaml).result(@helper.scope)) )
      rescue => err
        puts err.message + "\n" + err.backtrace.join("\n")
      end
    end
  end
end
