# standard library
module RNStdlib

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

  # readable escape from parsing interpolation
  def imitate_code(txt)
    "%#{txt};;"
  end
  alias im imitate_code

  # header of any level with 1 as default
  def header(level = 1, txt)
    enclose("h#{level}", txt)
  end

  # puts txt in 'tag' param
  def enclose(tag, txt = '')
    txtb = ''
    txtb = yield if block_given?

    l(tag) + txt + txtb + r(tag)
  end

  # left tag
  def l(txt)
    "<#{txt}>"
  end

  # right tag
  def r(txt)
    "</#{txt}>"
  end

  # encloses in 'strong' tag
  def strong(txt)
    enclose('strong', txt)
  end

  # encloses in 'code' tag
  def codify(txt)
    enclose('code', txt)
  end

  # 'br' tag
  def br
    '<br />'
  end

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

end
