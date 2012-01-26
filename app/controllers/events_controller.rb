class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    
    if params[:latitude] && params[:longitude]
      @events = Event.near origin: [params[:latitude].to_f, params[:longitude].to_f], within: 0.62
    elsif params[:code]
      @events = Event.find_by_code(params[:code]) || {}
    end
    
    respond_to do |format|
      format.json { render json: @events }
    end
  end
end
