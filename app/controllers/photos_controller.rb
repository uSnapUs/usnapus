class PhotosController < ApplicationController
  
  before_filter :get_event

  def index
    
    @photos = @event.photos
    
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
    
  end

  # POST /photos.json
  def create
    @photo = @event.photos.new(params[:photo])

    respond_to do |format|
      if @photo.save
        Pusher["event-#{@event.id}-photocast"].trigger!('new_photo', @photo)
        format.json { render json: @photo, status: :created}
        format.html {
          flash[:notice] = "Photo uploaded!"
          redirect_to event_photos_path(@event)
        }
      else
        format.html{
          p @photo.errors
          render "new"
        }
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
      @event = Event.visible.find(params[:event_id])
    end
  
end
