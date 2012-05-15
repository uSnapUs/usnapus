class PurchasesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :get_current_price
  before_filter :ssl_required
  
  def new
    if current_user.events.find_by_id(params[:event_id])
      @billing_detail = BillingDetail.new do |b|
        b.user = current_user
      end
    else
      raise ActiveRecord::RecordNotFound
    end
  end
  
  def create
    if @event = current_user.events.find_by_id(params[:event_id])
      
      pbd = params[:billing_detail]
      
      @billing_detail = current_user.billing_details.new do |bd|
        bd.card_name = pbd[:card_name]
        bd.card_type = pbd[:card_type]
        bd.month = pbd[:month]
        bd.year = pbd[:year]
        bd.number = pbd[:number]
        bd.verification_value = pbd[:verification_value]
      end
      
      unless @billing_detail.save
        flash.now[:error] = "You'll have to fix some things below:"
        render "new"
      else
        purchase = current_user.purchase(@event, @billing_detail, @price, "USD")
        
        if purchase.success?
          flash[:notice] = "Thanks! Your purchase was successful, here's your event:"
          Notifier.upgrade(current_user, @event).deliver
          @event.free=false
          @event.save!
          redirect_to event_photos_path(@event)
        else
          if purchase.errors[:credit_card]
            flash.now[:error] = "You have insufficient funds on this card"
            render :new and return
          elsif purchase.errors[:event_id]
            flash[:error] = "This event has already been purchased"
            redirect_to event_photos_path(@event)
          else
            flash.now[:error] = "There was an error! You haven't been charged."
            render :new and return
          end
        end
            
      end
    else
      raise ActiveRecord::RecordNotFound
    end
  end
  
end
