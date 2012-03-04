class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    
    @events = []
    
    if params[:latitude] && params[:longitude]
      @events = Event.near([params[:latitude].to_f, params[:longitude].to_f], 0.62)
    elsif params[:code]
      @events = Event.where(code: params[:code].upcase)
    end
    
    respond_to do |format|
      format.json { render json: @events }
    end
  end
  
  def new
  end
  
end
