module StreakClient
  
  class Box

    attr_accessor :name, :notes, :stageKey, :fields, 
      :followerKeys, :boxKey

    def initialize(attributes)
      attributes.each do |attr_name, attr_value|
        if self.respond_to?(attr_name)
          self.send("#{attr_name}=", attr_value) 
        end
      end
    end

    def self.api_url(pipeline_key)
      StreakClient.api_url + "/pipelines/#{pipeline_key}/boxes"
    end

    def self.instance_api_url(box_key, api_version = 'v1')
      StreakClient.api_url(api_version) + "/boxes/#{box_key}"
    end

    def self.create(pipelineKey, attributes)
      response = RestClient.put(self.api_url(pipelineKey), attributes)
      self.new(MultiJson.load(response))
    end

    def self.find(box_key)
      self.new(MultiJson.load(RestClient.get(self.instance_api_url(box_key))))
    end

    def self.delete(box_key)
      RestClient.delete(self.instance_api_url(box_key))
    end

    def self.all
      response = MultiJson.load(RestClient.get(self.instance_api_url(nil)))
      response.map {|box_attributes| self.new(box_attributes) }
    end

    def self.search_by_name(box_name)
      response = MultiJson.load(
          RestClient.get(StreakClient.api_url + "/search?name=#{box_name}"))

      return response['results']['boxes']
    end
  
    def newsfeed
      response = MultiJson.load(
        RestClient.get(Box.instance_api_url(boxKey) + "/newsfeed"))
      Newsfeed.new(events: response)
    end

    def threads
      response = MultiJson.load(
        RestClient.get(Box.instance_api_url(boxKey) + "/threads"))
      response.map {|thread_attributes| Thread.new(thread_attributes) }
    end

    def save!
      RestClient.post(Box.instance_api_url(boxKey), 
        {name: name, notes: notes, stageKey: stageKey}.to_json, content_type: :json)
    end

    # Matches Field keys with actual values taken from the given Pipeline
    # Returns a hash
    def read_fields(pipeline_key)
      pipeline_fields = Pipeline.find(pipeline_key).fields

      response = Hash.new

      fields.each do |box_field|
        next unless box_field[1].present?
        full_field = pipeline_fields.find { |pf| pf.key == box_field[0] }

        field_name = full_field.name
        field_value = case full_field.type
          when 'TAG'
            full_field.tagSettings['tags'].select { |tag| tag['key'].in? box_field[1] }.map { |f| f['tag'] }
          when 'DROPDOWN'
            full_field.dropdownSettings['items'].find { |item| item['key'] == box_field[1] }['name']
          when 'DATE'
            Time.at(box_field[1]/1000).to_date
          when 'PERSON'
            box_field[1].map { |person| "#{person['fullName']} (#{person['email']})" }
          else # 'TEXT_INPUT', 'CHECKBOX', or other
            box_field[1]
        end

        response[field_name] = field_value
      end

      response
    end

    def add_comment(message)
      response = MultiJson.load(
        RestClient.put(Box.instance_api_url(boxKey) + "/comments", "message=#{message}"))
    end

    def set_field(field_key, value)
      response = MultiJson.load(
        RestClient.post(Field.instance_api_url(boxKey, field_key), {value: value}.to_json, content_type: :json))
    end

    def add_thread(thread_gmail_id)
      response = MultiJson.load(
          RestClient.put(Box.instance_api_url(boxKey) + '/threads', "threadGmailId=#{thread_gmail_id}"))
    end

    def add_task(text, due_date)
      response = MultiJson.load(
          RestClient.post(Box.instance_api_url(boxKey, 'v2') + '/tasks', { text: text, dueDate: due_date }))
    end

  end

end
