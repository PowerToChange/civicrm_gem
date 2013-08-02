module CiviCrm
  class JSON
    class << self
      def parse(text)
        doc = text.is_a?(String) ? ActiveSupport::JSON.decode(text) : text

        array = []
        if doc["values"].respond_to?(:each_pair)
          doc["values"].each_pair do |key, value|
            array << value
          end
        elsif doc["values"]
          array = [doc["values"]].flatten
        else
          array << [doc]
        end

        array.map! { |item| parse_chains(item) }
      end

      private

      def parse_chains(doc)
        chained_api_key_matcher = /\Aapi\.([a-zA-Z]+)\.([a-zA-Z]+)/ # the key containing the result of a chained API request matches this format

        doc.select { |key, value| key =~ chained_api_key_matcher }.each do |key, value|
          new_key = chained_api_key_matcher.match(key).try(:[], 1) || key
          new_key = new_key.pluralize.downcase
          doc[new_key] = parse(doc.delete(key))
        end
        doc
      end

    end
  end
end