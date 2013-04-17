module CiviCrm
  class Contact < CiviCrm::Resource
    include CiviCrm::Actions::List
    include CiviCrm::Actions::Find
    #include CiviCrm::Actions::Create
    #include CiviCrm::Actions::Update
    #include CiviCrm::Actions::Destroy
    entity :contact
  end
end