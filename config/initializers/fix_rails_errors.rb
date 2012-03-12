# Monkey-patch routing layer to prevent Rails blindly using Object#inspect in generating error messages.
# This fixes super slow error responses on our app which has a large set of routes :)
# FIXME: We should remove this once Rails fixes this issue.
module ActionDispatch
  module Routing
    class RouteSet
      alias inspect to_s
    end
  end
end