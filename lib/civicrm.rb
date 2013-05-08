require 'active_support/deprecation'
require 'active_support/core_ext/module'
require 'active_support/core_ext/hash'
require 'active_support/inflector'
require 'rest-client'
require 'nokogiri'

# utils
require 'civicrm/client'
require 'civicrm/xml'
require 'civicrm/resource'
require 'civicrm/version'

# actions
require 'civicrm/actions/list'
require 'civicrm/actions/create'
require 'civicrm/actions/update'
require 'civicrm/actions/destroy'
require 'civicrm/actions/find'

# exceptions
require 'civicrm/errors'

# resources
require 'civicrm/resources/base'

module CiviCrm
  @@api_key = nil
  @@site_key = nil
  @@api_base = 'https://www.example.org/path/to/civi/codebase'
  @@api_version = 'v3'
  @@user_authenticated = false

  mattr_accessor :api_key, :api_base, :api_version, :site_key

  def self.api_url(path = '')
    base = "#{api_base}/civicrm/extern/rest.php?#{path}"
    base += "&api_key=#{@@api_key}" if @@api_key
    base += "&key=#{@@site_key}" if @@site_key
    base
  end

  def self.authenticate(name, password)
    auth = Client.request(:post, q: 'civicrm/login', name: name, pass: password)
    @@api_key = auth[0]['api_key']
  end
end