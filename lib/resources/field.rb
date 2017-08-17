module StreakClient

  class Field

    attr_accessor :key, :name, :type, :tagSettings, :dropdownSettings

    def initialize(attributes)
      attributes.each do |attr_name, attr_value|
        if self.respond_to?(attr_name)
          self.send("#{attr_name}=", attr_value) 
        end
      end
    end

    def self.pipeline_api_url(pipeline_key)
      StreakClient.api_url + "/pipelines/#{pipeline_key}/fields"
    end

    def self.instance_api_url(box_key, key)
      StreakClient.api_url + "/boxes/#{box_key}/fields/#{key}"
    end

    def self.create(pipelineKey, attributes)
      response = RestClient.put(self.pipeline_api_url(pipelineKey), attributes)
      self.new(MultiJson.load(response))
    end
  end
end