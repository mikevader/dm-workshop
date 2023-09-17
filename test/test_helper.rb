require 'simplecov'
SimpleCov.start do
  enable_coverage :branch
  add_filter "/test/"
  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Security", "app/policies"
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
Dir[Rails.root.join("test/support/**/*")].each { |f| require f }
Minitest::Reporters.use! unless ENV['RM_INFO']

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  # Returns true if a test user is logged in.
  def logged_in?
    !session[:user_id].nil?
  end

  # Logs in a test user.
  def log_in_as(user, options = {})
    password = options[:password] || 'password'
    remember_me = options[:remember_me] || '1'

=begin
    open_session do |sess|
      sess.post "/login", params: { session: {
                                      email: user.email,
                                      password: password,
                                      remember_me: remember_me} }
    end
=end

    post login_url, params: { session: {email: user.email,
                               password: password,
                               remember_me: remember_me} }
  end

  private

  # Returns true inside an integration test.
  def integration_test?
    defined?(post_via_redirect)
  end
end
