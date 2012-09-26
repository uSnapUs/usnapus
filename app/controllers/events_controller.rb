class EventsController < ApplicationController
  
  
  before_filter :authenticate_user!, except: [:index, :billing_test]
  before_filter :ssl_required, only: :billing_test
  
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
  
  def new
   redirect_to("http://blog.usnap.us/post/32311407686/final")
  end
  
  def billing_test
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
    redirect_to("http://blog.usnap.us/post/32311407686/final")
  end
  
  private
    def get_admin_event
      if at = Attendee.find_by_user_id_and_event_id_and_is_admin(current_user.id, params[:id], true)
        at.event
      end
    end
    
    def set_event_time(event)
      event.starts = Time.at(params[:event][:starts].to_i/1000) + 5.hours # 5am til
      event.ends = event.starts + 1.day # 5am
    end
    
end
