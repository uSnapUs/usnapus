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
  
end
