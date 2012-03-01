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
  
  def show
    #Could get here as /events/1 or /CODE
    if event = (Event.visible.find_by_id(params[:id]) || Event.visible.find_by_code(params[:code].try(:upcase)))
      redirect_to event_photos_path event
    else
      not_found
    end
  end
  
end
