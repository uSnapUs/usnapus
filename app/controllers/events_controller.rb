class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    
    @events = []
    
    if params[:latitude] && params[:longitude]
      @events = Event.current.near([params[:latitude].to_f, params[:longitude].to_f], 0.62)
    elsif params[:code]
      @events = Event.where(code: params[:code].upcase)
    end
    
    respond_to do |format|
      format.json { render json: @events }
    end
  end
  
  before_filter :authenticate_user!, :except => [:index]
  
  def new
    @event = Event.new(code: Event.generate_unique_code)
  end
  
  def edit
    unless @event = get_admin_event
      head :not_found and return
    end
  end
  
  def update
    unless @event = get_admin_event
      head :not_found and return
    end
    
    @event.assign_attributes(params[:event])
    
    set_event_time(@event)
    
    if @event.save
      flash[:notice] = "Changes saved!"
      redirect_to event_photos_path @event
    else
      flash.now[:error] = "Please fix the errors below"
      render "edit"
    end
    
  end
    
  
  def create
    @event = Event.new(params[:event].except(:free))
    
    set_event_time(@event)
    
    if params[:event] && (free = params[:event][:free])
      @event.free = free
    end
    
    if @event.save
      @event.attendees.create! do |at|
        at.user = current_user
        at.is_admin = true
      end
      unless @event.free
        flash[:notice] = "You're good to go! We'll invoice you soon"
      end
      
      if @event.eql? current_user.events.first
        Notifier.welcome(current_user, @event).deliver
      end
      
      redirect_to event_photos_path @event
    else
      flash[:error] = "Please fix the errors below"
      render "new"
    end
  end

  def upgrade
    unless @event = get_admin_event
      head :not_found and return
    end
    
    Notifier.upgrade(current_user, @event).deliver
    flash[:notice] = "Thanks! You've been upgraded, and we'll invoice you soon."
    @event.free = false
    @event.save!
    
    redirect_to event_photos_path(@event)
  end
  
  private
    def get_admin_event
      if at = Attendee.find_by_user_id_and_event_id_and_is_admin(current_user.id, params[:id], true)
        at.event
      end
    end
    
    def set_event_time(event)
      event.starts = Time.at(params[:event][:starts].to_i/1000).beginning_of_day + 6.hours
      event.ends = event.starts + 1.day
    end
    
end
