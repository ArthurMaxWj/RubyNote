# standard library
module RNStdlib
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

end
