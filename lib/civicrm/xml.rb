module CiviCrm
  class XML
    class << self
      def parse(text)
        doc = Nokogiri::XML.parse(text.to_s.gsub("\n", ''))
        results = doc.xpath('//Result')
        results.map do |result|
          hash = {}
          result.children.each do |attribute|
            next unless attribute.is_a?(Nokogiri::XML::Element)
            hash[attribute.name] = attribute.children[0].text rescue nil
          end
          hash
        end
      end
    end
  end
end