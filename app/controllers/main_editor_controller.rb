require './rubynote/rubynote'

class MainEditorController < ApplicationController
  protect_from_forgery :except => :preprocess

  def index
  end

  def preprocess
    e = RNBasicEnv.new(params['code'])
    $RN_ENV = e
    e.preprocess
    @cnv = e.converted
  end
end