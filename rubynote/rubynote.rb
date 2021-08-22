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

  # switches off\on html with :plain\:html
  def docmode(mode)
    @is_plain = mode == :plain
    nil # hides displaying
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

  def render_note(text)
    pattern = /(?<plain>([^%]|%%)*)%(?<code>[^%]([^;]|;[^;])*);;/

    res = ''
    last_pos = 0
    text.scan(pattern) do |mobj|
      res += if @is_plain
          dehtmlize(mobj[0])
        else
          mobj[0]
             end

      res += rubify(mobj[1])

      bgn = Regexp.last_match.begin(1)
      last_pos = (bgn + (mobj[1].length + mobj[0].length) + 3)
    end

    res + text[last_pos..]
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
    @is_plain = false # for 'docmode' from RNExtensions
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
end