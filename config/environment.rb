# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# Speeding up HAML and removing scaffolding
# http://chriseppstein.github.io/blog/2010/02/08/haml-sucks-for-content/
Haml::Template.options[:ugly] = true
