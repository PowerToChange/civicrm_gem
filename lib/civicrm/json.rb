module CiviCrm
  class JSON
    class << self
      def parse(text)
        array = []
        doc = ActiveSupport::JSON.decode(text)
        if doc["values"].respond_to?(:each_pair)
          doc["values"].each_pair do |key, value|
            array << value
          end
        else
          array << doc
        end
        array
      end
    end
  end
end