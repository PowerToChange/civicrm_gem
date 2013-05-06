module CiviCrm
  class BaseResource < CiviCrm::Resource
    include CiviCrm::Actions::List
    include CiviCrm::Actions::Find
    include CiviCrm::Actions::Create
    include CiviCrm::Actions::Update
    include CiviCrm::Actions::Destroy
  end
end
module CiviCrm
  class Activity < BaseResource
    entity :activity
  end
  class ActivityType < BaseResource
    entity :activity_type
  end
  class Address < BaseResource
    entity :address
  end
  class Batch < BaseResource
    entity :batch
  end
  class Campaign < BaseResource
    entity :campaign
  end
  class Case < BaseResource
    entity :case
  end
  class Constant < BaseResource
    entity :constant
  end
  class Contact < BaseResource
    entity :contact
  end
  class ContactType < BaseResource
    entity :contact_type
  end
  class Contribution < BaseResource
    entity :contribution
  end
  class ContributionPage < BaseResource
    entity :contribution_page
  end
  class ContributionRecur < BaseResource
    entity :contribution_recur
  end
  class CustomField < BaseResource
    entity :custom_field
  end
  class CustomGroup < BaseResource
    entity :custom_group
  end
  class CustomSearch < BaseResource
    entity :custom_search
  end
  class CustomValue < BaseResource
    entity :custom_value
  end
  class Domain < BaseResource
    entity :domain
  end
  class Email < BaseResource
    entity :email
  end
  class Entity < BaseResource
    entity :entity
  end
  class EntityTag < BaseResource
    entity :entity_tag
  end
  class Event < BaseResource
    entity :event
  end
  class Extension < BaseResource
    entity :extension
  end
  class File < BaseResource
    entity :file
  end
  class Grant < BaseResource
    entity :grant
  end
  class Group < BaseResource
    entity :group
  end
  class GroupContact < BaseResource
    entity :group_contact
  end
  class GroupNesting < BaseResource
    entity :group_nesting
  end
  class GroupOrganization < BaseResource
    entity :group_organization
  end
  class Im < BaseResource
    entity :im
  end
  class Job < BaseResource
    entity :job
  end
  class LineItem < BaseResource
    entity :line_item
  end
  class LocBlock < BaseResource
    entity :loc_block
  end
  class Location < BaseResource
    entity :location
  end
  class LocationType < BaseResource
    entity :location_type
  end
  class MailSettings < BaseResource
    entity :mail_settings
  end
  class Mailing < BaseResource
    entity :mailing
  end
  class Membership < BaseResource
    entity :membership
  end
  class Note < BaseResource
    entity :note
  end
  class Phone < BaseResource
    entity :phone
  end
  class Profile < BaseResource
    entity :profile
  end
  class Setting < BaseResource
    entity :setting
  end
  class Survey < BaseResource
    entity :survey
  end
  class SurveyRespondant < BaseResource
    entity :survey_respondant
  end
end