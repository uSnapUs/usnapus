class DevicesController < ApplicationController

  # POST /devices.json
  def create
    @device = Device.new(params[:device])

    respond_to do |format|
      if @device.save
        format.json { render json: @device, status: :created }
      else
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT /devices/:id.json
  def update
    @device = Device.find(params[:id])
    @device.assign_attributes(params[:device])

    respond_to do |format|
      if @device.save
        format.json { render json: @device, status: :created }
      else
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end
end
