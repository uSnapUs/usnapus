module ApplicationHelper
  
  def hours_array
    ["12am"] + (1..11).map{|i|"#{i}am"} + ["12pm"] + (1..11).map{|i|"#{i}pm"}
  end
  
  def event_code_path(event, options = {})
    "/#{event.code}#{options[:suffix]}"
  end
  
end
