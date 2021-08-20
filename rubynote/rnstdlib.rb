# standard library
module RNStdlib

  def header(txt)
    "<h1>#{txt}</h1>"
  end

  def enclose(tag, txt = '', &block)
    l(tag) + txt + block.call + r(tag)
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
