module Web
  module Controllers
    module Feeds
      class Show
        include Web::Action

        # def initialize; end # dependency injection

        def call(params)
        end
      end
    end
  end
end

# Web::Controllers::Reeds::Show.new # => object
# Web::Controllers::Reeds::Show.new.call({ ... }) # => call action
