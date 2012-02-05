class PhotosController < ApplicationController
  
  before_filter :get_event

  def index
    @photos = @event.photos
    
    respond_to do |format|
      format.html
      format.json { render json: @photos}
    end
  end
  
  def fullscreen
    
  end

  # POST /photos.json
  def create
    params[:photo][:event_id] = nil #They can't specify it as an attribute, they have to use the URL
    
    @photo = @event.photos.new(params[:photo])

    respond_to do |format|
      if @photo.save
        Pusher["event-#{@event.id}-photocast"].trigger!('new_photo', @event.photos.sample)
        format.json { render json: @photo, status: :created}
      else
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @photo = @event.photos.find(params[:id])
    
    respond_to do |format|
      if @photo.destroy
        format.json { head :ok }
      else
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
    def get_event
      @event = Event.find(params[:event_id])
    end
  
end
