require './rubynote/rnstdlib'

module RNExtensions

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
    noth # hides displaying
  end

end


module RNSecurity

  def require(mod)
    if RubyNoteMehanics.is_permitted?(mod)
      super
    else
      $RN_ENV.error_found(:mod_add, msg = "Required '#{mod}' not permitted in current instance of RubyNote.")
    end
  end

  class << BasicObject
    alias old_inst_eval instance_eval
    def instance_eval(&block)
      Class.new(self).extend(RNSecurity).old_inst_eval(&block)
    end
  end
end

module RubyNoteParser

  def rubify(code)
    eval(code).to_s
  end

  def modify_no_code(no_code)
    # this is for 'StdLib::SpacingTools'
    # OPTIMIZE replace with method not depending on AcrtiveSupport and one that doesn't delete the right whitespace
    no_code = no_code.squish if @doc_state[:skip_next]
    @doc_state[:skip_next] = false unless @doc_state[:super_skip]

    # this is for 'docmode' from 'RNExtensions'
    no_code = dehtmlize(no_code) if @doc_state[:is_plain]

    no_code
  end

  def render_note(text)
    pattern = /(?<plain>([^%]|%%)*)%(?<code>[^%]([^;]|;[^;])*)?;;/

    res = ''
    last_pos = 0
    text.scan(pattern) do |mobj|
      no_code = modify_no_code(mobj[0])

      res += no_code

      res += rubify(mobj[1])

      bgn = Regexp.last_match.begin(1)
      last_pos = (bgn + (mobj[1].length + mobj[0].length) + 3)
    end

    res + modify_no_code(text[last_pos..]) # adds no-code from the end of file (with applied modify_no_code)
  end

  def dehtmlize(html)
    html.gsub('&', '&amp;').gsub('<', '&lt;').gsub('>', '&gt;')
  end

end


class RubyNoteMehanics
  include RubyNoteParser
  include RNSecurity
  include RNExtensions

  attr_reader :converted, :note_plain

  def initialize(note_str)
    @note_plain = note_str
    @doc_state = {
      is_plain: false, # for 'docmode' from RNExtensions
      skip_next: false, # for 'RNStdLib::SpaceTools'
      super_skip: false, # same
      pre: false # for RNStdlib's 'set_pre'
    }
  end

  def preprocess
    $RN_ENV ||= self # for RNSecurity's 'preapre' (recursive)
    instance_exec(@converted, @note_plain) do
      @converted = render_note(@note_plain)
    end
  end

  def self.is_permitted?(mod)
    ['JSON'].include?(mod)
  end
end

#--------------------------------------------------------------------------------

# including standard library
class RNBasicEnv < RubyNoteMehanics
  include RNStdlib

  def initialize(note_str)
    super
    @doc_state[:pre] = true
  end

  def preprocess
    super
    @converted = '<pre>' + @converted # adds first 'pre' tag because of @pre = true (in initialize)
    @converted += '</pre>' if @doc_state[:pre] # closes all opened 'pre'
  end
end
