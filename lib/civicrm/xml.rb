module CiviCrm
  class XML
    class << self
      def decode(text)
        Ox.load(text)
      end

      def encode(xml)
        Ox.parse_obj(xml)
      end
    end
  end
end