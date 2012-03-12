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
  
  before_filter :authenticate_user!, :except => [:index]
  
  def new
    @event = Event.new
  end
  
  def edit
    if at = Attendee.find_by_user_id_and_event_id_and_is_admin(current_user.id, params[:id], true)
      @event = at.event
    else
      head :not_found
    end
  end
  
  def create
    @event = Event.new(params[:event])
    
    if @event.save
      @event.attendees.create! do |at|
        at.user = current_user
        at.is_admin = true
      end
      
      flash[:notice] = "Here's your event! Start snapping :)"
      redirect_to event_photos_path @event
    else
      flash[:error] = "Please fix the errors below"
      render "new"
    end
  end
  
end
