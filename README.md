## Installation

* $ gem install civicrm

## Getting started

```ruby
* CiviCrm.site_key = 'YOUR_SITE_KEY'
* // More info about site_key:
* // http://wiki.civicrm.org/confluence/display/CRMDOC43/Managing+Scheduled+Jobs
* CiviCrm.api_base = 'https://www.example.org/path/to/civi/codebase/'
* CiviCrm.authenticate('demo', 'demo')
```

## CiviCrm Objects

```ruby
* CiviCrm::Contact.all    # get list of contacts
* CiviCrm::Contact.create(contact_type: 'Organization', organization_name: 'test') # create contact
* CiviCrm::Contact.find(1).delete      # find and delete
```

## Testing
```
rspec spec
```

## Useful links

* http://wiki.civicrm.org/confluence/display/CRMDOC43/REST+interface
* http://drupal.demo.civicrm.org/civicrm/api/explorer