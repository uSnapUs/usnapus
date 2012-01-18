class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    @events = Event.near origin: [params[:latitude].to_f, params[:longitude].to_f], within: 0.62

    respond_to do |format|
      format.json { render json: @events }
    end
  end
end
