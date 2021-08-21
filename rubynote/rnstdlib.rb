# standard library
module RNStdlib

  def header(txt)
    "<h1>#{txt}</h1>"
  end

  def enclose(tag, txt = '', &block)
    txtb = ''
    txtb = block.call if block_given?

    l(tag) + txt + txtb + r(tag)
  end

  def l(txt)
    "<#{txt}>"
  end

  def r(txt)
    "</#{txt}>"
  end


  def strong(txt)
    '<strong>' + txt + '</strong>'
  end

  def codify(txt)
    '<code>' + txt + '</code>'
  end

end
