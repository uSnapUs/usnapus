class PurchasesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :ssl_required
  
  def new
    if (@event = current_user.events.find_by_id(params[:event_id])) && !@event.purchased?
      if current_user.events.find_by_id(params[:event_id])
        @billing_detail = BillingDetail.new do |b|
          b.user = current_user
        end
      else
        raise ActiveRecord::RecordNotFound
      end
    else
      flash[:notice] = "No need to pay twice :)"
      redirect_to event_photos_path(@event)
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
        @event.currency = current_currency
        @event.save!
        
        purchase = current_user.purchase(@event, @billing_detail, @event.pricing_tier.price_in_currency(@event.currency), @event.currency)
        
        if purchase.was_successful?
          flash[:notice] = "Thanks! Your purchase was successful, here's your event:"
          Notifier.upgrade(current_user, @event).deliver
          @event.free=false
          @event.save!
          redirect_to event_photos_path(@event)
        else
          if purchase.errors[:event_id].any?
            flash[:error] = "This event has already been purchased"
            redirect_to event_photos_path(@event)
          elsif purchase.errors[:charge_attempt_id].any?
            flash.now[:error] = "We couldn't charge your credit card: #{purchase.errors[:charge_attempt_id].to_sentence}. Need help? Email team@usnap.us"
            render "new"
          else
            flash.now[:error] = "There was an error! You haven't been charged."
            render "new"
          end
        end
            
      end
    else
      raise ActiveRecord::RecordNotFound
    end
  end
  
end
