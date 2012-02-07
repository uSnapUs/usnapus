class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    proxy = Event
    
    if params[:latitude] && params[:longitude]
      proxy = proxy.current.near origin: [params[:latitude].to_f, params[:longitude].to_f], within: 0.62
    elsif params[:code]
      proxy = proxy.where(code: params[:code])
    end
    
    @events = proxy.all
    
    respond_to do |format|
      format.json { render json: @events }
    end
  end
end
