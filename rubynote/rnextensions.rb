module RNExtensions

  # helps modify no-code, parts between interpolated code and other dynamic features
  class RNExtension
    @@extensions = {}
    @@near_mod = nil

    attr_reader :exported

    proc{
      def init_exported(mod)
        raise '"exported" alredady initalized' unless @exported.nil?

        @exported = mod
      end
    }


    def self.all_extensions
      @@extensions.values
    end

    def self.extension_named(name)
      @@extensions[name]
    end

    def self.export(&block)
      @@near_mod = Module.new(&block)
    end

    def self.extension(name, &block)
      @@extensions[name] = Class.new(RNExtension, &block).new(@@near_mod)
    end

    # ------------------

    # <abstract/virtual> use instead of doc_state unless you want to share
    def initialize(mod)
      @exported = mod # for now simply nil
    end

    # allows changing of text between interpolation (called for each such text)
    def transform(no_code)
      no_code
    end

    # inserts before whole RubyNote (called at the end)
    def start
      noth
    end

    # inserts after whole RubyNote (called at the end)
    def finish
      noth
    end

  end



  module RExShort
    # alias for RNExtension.extension
    def extension(name, &block)
      RNExtension.extension(name, &block)
    end

    # for syntax 'include :ExtensionsName.rex'
    def rex(name)
      RNExtension.extension_named(name).exported
    end
  end

end
