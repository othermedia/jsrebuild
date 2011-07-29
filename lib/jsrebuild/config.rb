module JSRebuild
  
  class Config < Jake::Build
    def source_files
      @packages.inject([]) { |files, (_, pkg)|
        files.concat(pkg.files)
      }
    end
    
    def config_file
      Jake.path(@dir, Jake::CONFIG_FILE)
    end
    
    def helper_file
      Jake.path(@dir, Jake::HELPER_FILE)
    end
  end
end
