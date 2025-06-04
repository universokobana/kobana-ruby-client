# frozen_string_literal: true

desc "Start an interactive console"
task :console do
  require "irb"

  # Load the application environment if needed
  require File.expand_path("../kobana.rb", __dir__)

  # Start the IRB session
  IRB.start
end
