class EventsController < ApplicationController
  
  
  before_filter :authenticate_user!, except: [:index, :billing_test]
  before_filter :ssl_required, only: :billing_test
  before_filter :get_current_price
  
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
    @event = Event.new(code: Event.generate_unique_code)
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
    if params[:event]
      @event = Event.new(params[:event].except(:free))
    
      set_event_time(@event)
      #always free on create, have to put in billing to make it not free
      @event.free=true
      
      
      if (lp = LandingPage.find_by_path(session[:landing_page]))
        @event.landing_page = lp
      end
    
      if @event.save
        @event.attendees.create! do |at|
          at.user = current_user
          at.is_admin = true
        end
        unless @event.free
          flash[:notice] = "You're good to go! We'll invoice you soon"
          Notifier.upgrade(current_user, @event).deliver
        end
      
        if @event.eql? current_user.events.first
          Notifier.welcome(current_user, @event).deliver
        end
        
        if params[:event] && (free = params[:event][:free])
          if free=="1"            
             redirect_to event_photos_path @event
          else

            redirect_to new_event_purchase_path @event
          end
        else
            redirect_to new_event_purchase_path @event
        end
      else
        flash[:error] = "Please fix the errors below"
        render "new"
      end
    else
      redirect_to new_event_path
    end
  end

  def upgrade
    unless @event = get_admin_event
      head :not_found and return
    end
    
   
    redirect_to new_event_purchase_path @event
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
