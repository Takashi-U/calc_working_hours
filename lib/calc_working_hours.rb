require "calc_working_hours/version"
require "active_support/dependencies"

module CalcWorkingHours
end

ActiveSupport::Dependencies.autoload_paths << File.expand_path('..', __FILE__)
ActiveSupport::Dependencies.autoload_paths << File.expand_path('../calc_working_hours', __FILE__)
