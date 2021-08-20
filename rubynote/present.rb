require './rubynote/rubynote'


# include your modules and overrides here
class RNDeafultEnv < RNBasicEnv
  # ...
end

def present
  error = '%require "JSONX";;'
  fine = '%require "JSON";;'
  code = '%codify((2+2).to_s);;'
  complex = '%String.instance_eval {require "JSONX"};;'
  very_complex = '%String.instance_eval {String.instance_eval {require "JSONX"}};;' # recursion works perfectly

  e = RNDeafultEnv.new(code)
  $RN_ENV = e
  e.preprocess
  puts e.note_plain
  puts e.converted
end

present

