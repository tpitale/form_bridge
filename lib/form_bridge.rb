require "form_bridge/version"
require "logger"
require "optparse"
require "securerandom"
require "json"
require "gdbm"
require "rack"
require "rack/handler/puma"

module FormBridge
  module_function def map(options, &block)
    FormBridge::Handler.new(FormBridge::Router.build(options, &block))
  end
end

require "form_bridge/cli"
require "form_bridge/router"
require "form_bridge/handler"
require "form_bridge/persistance"

require "form_bridge/models/form" # => FormBridge::Form
require "form_bridge/models/submission" # => FormBridge::Submission

require "form_bridge/endpoint/forms/new"
require "form_bridge/endpoint/forms/show"
require "form_bridge/endpoint/submissions/create"
