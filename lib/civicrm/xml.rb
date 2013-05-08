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
      def encode(resources)
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.ResultSet do
            Array.wrap(resources).each do |resource|
              attributes = resource.respond_to?(:attributes) ? resource.attributes : resource
              xml.Result do
                attributes.each do |key, value|
                  xml.send key.to_sym, value
                end
              end
            end
          end
        end
        builder.to_xml
      end
    end
  end
end