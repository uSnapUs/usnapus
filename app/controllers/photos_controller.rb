class PhotosController < ApplicationController
  
  before_filter :get_event

  def index
    
    @photos = @event.photos.processed.order("created_at DESC")
    if before_id = params[:before]
      @photos = @photos.where("id < ?", before_id)
    end
    if limit = params[:limit]
      @photos = @photos.limit(limit.to_i)
    end
    
    @attendee = Attendee.between(current_user, @event) if current_user
    
    respond_to do |format|
      format.html
      format.json { 
        headers["Cache-Control"] = 'no-cache, no-store'
        render json: @photos
      }
    end
  end
  
  def new
    @photo = @event.photos.new
  end
  
  def fullscreen
    render :layout => false
  end

  # POST /photos.json
  def create
    @photo = @event.photos.new(params[:photo].slice(:photo))
                                      #Legacy
    @photo.creator = current_thing || (Device.find_by_id(params[:photo][:device_id]) if params[:photo])
    
    
    respond_to do |format|
      if @photo.save
        format.json { render json: @photo, status: :created}
        format.html {
          flash[:notice] = "Yay! We're processing your photo and you'll see it soon..."
          redirect_to event_photos_path(@event)
        }
      else
        format.html{
          render "new"
        }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @photo = current_thing.photos.find_by_id(params[:id]) if current_thing
    
    respond_to do |format|
      if @photo && @photo.destroy
        format.json { head :ok }
      else
        format.json { head :not_found }
      end
    end
  end
  
  private
    def get_event
      
      #Signed in users can get their events by id or code
      #Devices can get all events by id or code
      #Public can get public events by code only
      
      events =  if current_user
                  get_event_by_param Event.joins(:attendees).where("attendees.user_id = ?", current_user.id)
                elsif current_device
                  get_event_by_param Event
                else
                  Event.visible.where(:code => params[:code]) if params[:code]
                end
     
      if request.post? && params[:photo] && params[:photo][:device_id]
        #Legacy to let devices create new photos
        @event = get_event_by_param(Event).first
      
      #No events, 404  
      elsif !events || !(@event = events.first)
        raise ActiveRecord::RecordNotFound
      end
      
    end
    
    def get_event_by_param(proxy)
      if id = params[:event_id]
        proxy.where("events.id = ?", id)
      elsif code = params[:code]
        proxy.where("events.code = ?", code)
      end
    end
    
    def current_thing
      current_user || current_device
    end
  
end
