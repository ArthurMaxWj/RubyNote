require './rubynote/rnextensions'

# standard library
module RNStdlib
  include ::RNExtensions
  extend RExShort

  module Basic
    # used to manage both param textual values and blocks (concats them, handles empty)
    def block_extract(value)
      if block_given?
        value + yield
      else
        value
      end
    end

    # readable escape from parsing interpolation
    def imitate_code(txt)
      "%#{txt};;"
    end
    alias im imitate_code

    # puts txt in 'tag' param
    def enclose(tag, txt = '', &block)
      txtbb = block_extract(txt, &block)

      l(tag) + txtbb + r(tag)
    end

    # left tag
    def l(txt)
      "<#{txt}>"
    end

    # right tag
    def r(txt)
      "</#{txt}>"
    end

  end
  include ::RNStdlib::Basic

  module HTML
    # 'br' tag
    def br
      '<br />'
    end

    def css(style, val, &block)
      txt = block_extract(val, &block)
      "<span style=\"#{style}\">#{txt}</span>"
    end

    # header of any level with 1 as default
    def header(level = 1, txt)
      enclose("h#{level}", txt)
    end

    # encloses in 'strong' tag
    def strong(txt)
      enclose('strong', txt)
    end

    # encloses in 'code' tag
    def codify(txt)
      enclose('code', txt)
    end
  end
  include ::RNStdlib::HTML


  def set_pre(p)
    return noth if @doc_state[:pre] == p

    if p
      @doc_state[:pre] = true
      '<pre>'
    else
      @doc_state[:pre] = false
      '</pre>'
    end
  end

  module ToDecompose

    # to be implemented overridden in subclasses, handles any 'err_type' symbols and 'msg'
    def handle_error(err_type, msg = 'Undefined parser error')
      "<div class='rn-error'>(#{err_type.to_s}): #{msg}</div>"
    end

    def error_found(err_type, msg = 'Undefined parser error')
      case err_type
      when :mod_add
        "<div class='rn-error'>Failed at requiring module (:mod_add): #{msg}</div>"
      else
        handle_error(err_type, msg)
      end
    end

    # hides displaying (basically just an internal abstraction for future)
    def nothing_text
      nil
    end
    alias noth nothing_text

    # switches off\on html with :plain\:html
    def docmode(mode)
      @doc_state[:is_plain] = mode == :plain
      noth
    end

  end
  include ::RNStdlib::ToDecompose


  extension :set_pre do
    def initialize(mod)
      super(mod)
      @pre = true
    end

    def start
      '<pre>'
    end

    def finish
      '</pre>' if @pre
    end

    export do
      def set_pre(p)
        return noth if @doc_state[:pre] == p

        if p
          @doc_state[:pre] = true
          '<pre>'
        else
          @doc_state[:pre] = false
          '</pre>'
        end
      end
    end
  end
  include rex :set_pre
  #. puts "[[:#{RNExtension.all_extensions}:]]"


  module SpacingTools

    def skip
      @doc_state[:skip_next] = true
      noth
    end
    alias s skip

    def skip_space_start
      @doc_state[:super_skip] = true
      @doc_state[:skip_next] = true
      noth
    end
    alias ss skip_space_start

    def skip_space_end
      @doc_state[:super_skip] = false
      @doc_state[:skip_next] = false
      noth
    end
    alias se skip_space_end

    def s_br
      skip
      br
    end

    def ss_br
      skip_space_start
      br
    end

    def se_s
      skip_space_start
      skip
      noth
    end

  end
  include ::RNStdlib::SpacingTools


  module ComponentsSupport

    # a function that doesn't modify it's arguments
    # FP idea that can me used to set as default for some lambdas
    def identity
      ->(x){x}
    end
    alias idnt identity

    # registers a component with given name
    # (preferably snake-case symbol, can be like small description eg. ':list_of_labelled_things')
    # 'outer' and 'inner' default to 'identity' function's result
    # 'outer' modifies component output, while 'inner' modifies the input
    # they are treated like lambad and called with '.()'
    def component_new(name, outer: nil, inner: nil, &block)
      inner ||= idnt
      outer ||= idnt
      @doc_state[:components][name] = proc { |val|
        outer.( yield(inner.(val)) )
      }
      noth
    end

    # inserts component by given name
    def component(name, value = '', &block)
      txt = block_extract(value, &block)
      @doc_state[:components][name].call(txt)
    end

  end
  include ::RNStdlib::ComponentsSupport

end
