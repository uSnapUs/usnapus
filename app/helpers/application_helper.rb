module ApplicationHelper
  
  def hours_array
    ["12am"] + (1..11).map{|i|"#{i}am"} + ["12pm"] + (1..11).map{|i|"#{i}pm"}
  end
  
  def event_code_path(event, options = {})
    "/#{event.code}#{options[:suffix]}"
  end
  
  def pretty_price(amount_in_cents, currency = "USD")
    "#{currency}$#{amount_in_cents.to_i/100}"
  end
  
  def pretty_current_price
    pretty_price current_price, current_currency
  end
  
  def change_currency_link
    opposite_currency = current_currency.eql?("USD") ? "NZD" : "USD"
    link_to "Wrong currency? Change to #{opposite_currency}", change_currency_path, data: {new_currency: opposite_currency}, class: "change_currency"
  end
  
end
