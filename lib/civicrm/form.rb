module CiviCrm
  class Form
    attr_accessor :params, :values, :errors, :html_options

    def initialize(params = {})
      @params = options[:params]
      @values = {}
      @errors = {}
      @html_options = {}
    end

    def add_params(params = {})
      self.params.merge!(params)
    end

    def render
      "#{render_html} #{render_javascript}".html_safe
    end

    def render_javascript
      html = <<-TEXT
        <script type="text/javascript">
          CiviCrm.setEndpoint('#{CiviCrm.api_url}');
          CiviCrm.setPublishableKey("#{CiviCrm.publishable_key}");
          CiviCrm.form.build(#{javascript_form_params});
        </script>
      TEXT
    end

    def render_html
      html = <<-TEXT
        <form id="#{@html_options[:id] || 'civicrm'}" class="#{@html_options[:class]}"></form>
      TEXT
    end

    private
      def javascript_form_params
        params_html = "$('##{@html_options[:id]}'), #{@params.to_json}, #{@values.to_json}"
        params_html << ", #{@errors.to_json}" if @errors.present?
        params_html
      end
  end
end