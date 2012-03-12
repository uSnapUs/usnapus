module ApplicationHelper
  
  def hours_array
    ["12am"] + (1..11).map{|i|"#{i}am"} + ["12pm"] + (1..11).map{|i|"#{i}pm"}
  end
  
end
