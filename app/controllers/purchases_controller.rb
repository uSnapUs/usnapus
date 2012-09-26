class PurchasesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :ssl_required
  
  def new
    redirect_to("http://blog.usnap.us/post/32311407686/final")
  end
  
  def create
   redirect_to("http://blog.usnap.us/post/32311407686/final")
  end
  
end
