module CiviCrm
  class Contact < CiviCrm::Resource
    include CiviCrm::Actions::List
    include CiviCrm::Actions::Create
    include CiviCrm::Actions::Update
    include CiviCrm::Actions::Destroy
    include CiviCrm::Actions::Find
    resource :wallet
  end
end