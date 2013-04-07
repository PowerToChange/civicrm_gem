require 'active_support/deprecation'
require 'active_support/core_ext/module'
require 'active_support/core_ext/hash'
require 'active_support/inflector'
require 'rest-client'
require 'oj'

# utils
require 'civicrm/client'
require 'civicrm/json'
require 'civicrm/resource'
require 'civicrm/version'
require 'civicrm/form'

# actions
require 'civicrm/actions/list'
require 'civicrm/actions/create'
require 'civicrm/actions/update'
require 'civicrm/actions/destroy'
require 'civicrm/actions/find'

# exceptions
require 'civicrm/errors'

# resources
require 'civicrm/resources/list'
require 'civicrm/resources/charge'
require 'civicrm/resources/wallet'
require 'civicrm/resources/customer'
require 'civicrm/resources/reward'
require 'civicrm/resources/coupon'
require 'civicrm/resources/event'
require 'civicrm/resources/payout'
require 'civicrm/resources/log'

module CiviCrm
  @@api_key = nil
  @@api_base = 'https://www.example.org/path/to/civi/codebase'
  @@api_version = 'v3'
  @@user_authenticated = false
  @@user_key = nil

  mattr_accessor :api_key, :api_base, :api_version

  def self.api_url(path = '')
    base = "#{api_base}/civicrm/extern/rest.php?q=civicrm#{path}"
    base += "&key=#{@@user_key}" if @@user_authenticated
    base += "&api_key=#{@@api_key}" if @@api_key
    base
  end

  def authenticate(name, password)
    auth = Client.request(:get, '/login', name: name, password: password)
    # TODO: add implementation
    @@user_authenticated = true
    @@user_key = ''
  end
end