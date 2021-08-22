require './rubynote/rubynote'


# include your modules and overrides here
class RNDeafultEnv < RNBasicEnv
  # ...
end

def present
  proc {
  error = '%require "JSONX";;'
  fine = '%require "JSON";;'
  code = '%codify((2+2).to_s);;'
  complex = '%String.instance_eval {require "JSONX"};;'
  very_complex = '%String.instance_eval {String.instance_eval {require "JSONX"}};;' # recursion works perfectly
  }

  code = "%header('An Example');;  \n2+2 = %codify((2+2).to_s);;\n%header('We are using RNStdlib to write code in pre element.');;"

  e = RNDeafultEnv.new(code)
  $RN_ENV = e
  e.preprocess
  puts e.note_plain
  puts e.converted

  require 'json'
  h = { 'converted' => e.converted}.to_json
  puts h
end

present

