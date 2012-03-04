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
    @photo = @event.photos.new(params[:photo])
    
    respond_to do |format|
      if @photo.save
        format.json { render json: @photo, status: :created}
        format.html {
          flash[:notice] = "Yay! We're processing your photo and you'll see it soon..."
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
    @photo = Photo.find_by_id_and_event_id_and_device_id(params[:id], @event.id, current_device.id)
    
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
      unless @event = if current_user #User can only see their events
                        current_user.events.find_by_id(params[:event_id])
                      elsif current_device #Device can see all events
                        Event.find_by_id(params[:event_id])
                      else #Public can only see by code
                        Event.find_by_code(params[:code].try(:upcase))
                      end
        head 404
      end
    end
  
end
