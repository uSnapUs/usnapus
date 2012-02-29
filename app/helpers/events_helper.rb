module EventsHelper
  
  def pretty_time event
    #If the event is multiday, show the dates
    if event.starts
      if event.starts + 1.day < event.ends
        "#{event.starts.strftime("%-d")} - #{event.ends.strftime("%-d %B")}"
      else
        "#{event.starts.strftime("%l%P")} - #{event.ends.strftime("%l%P, #{(event.ends.day-1.second).ordinalize} %B")}"
      end
    end
  end  
  
end