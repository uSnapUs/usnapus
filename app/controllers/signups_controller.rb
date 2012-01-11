class SignupsController < ApplicationController

  # POST /signups
  # POST /signups.json
  def create
    @signup = Signup.new(params[:signup])
    
    respond_to do |format|
      if @signup.save
        format.json { render json: @signup, status: :created }
      else
        format.json { render json: @signup.errors, status: :unprocessable_entity }
      end
    end
  end
  
end
