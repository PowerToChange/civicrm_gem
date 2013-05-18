# Mock response from Civicrm with a body and code attributes

 module CiviCrm::TestResponses
  def test_response(body, code = 200)
    m = mock
    m.instance_variable_set('@data', { body: body, code: code})
    def m.body; @data[:body]; end
    def m.code; @data[:code]; end
    m
  end
end