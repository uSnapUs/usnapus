class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    proxy = Event
    
    if params[:latitude] && params[:longitude]
      proxy = proxy.current.near origin: [params[:latitude].to_f, params[:longitude].to_f], within: 0.62
    elsif params[:code]
      proxy = proxy.where(code: params[:code].upcase)
    end
    
    @events = proxy.all
    
    respond_to do |format|
      format.json { render json: @events }
    end
  end
  
  def show
    #Could get here as /events/1 or /CODE
    if event = (Event.find_by_id(params[:id]) || Event.find_by_code(params[:code]))
      redirect_to event_photos_path event
    else
      not_found
    end
  end
  
end
