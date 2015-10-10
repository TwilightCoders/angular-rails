require 'rails/version'

module Angular
  module Rails
    if defined? ::Rails::Engine
      require 'rails/engine'
    elsif defined? Sprockets
      require 'rails/sprockets'
    end
  end
end
