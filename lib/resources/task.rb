module StreakClient

  class Task

    attr_accessor :key, :creatorKey, :creationDate, :dueDate, :text, :status,
        :reminderStatus, :assignedToSharingEntries

    def initialize(attributes)
      attributes.each do |attr_name, attr_value|
        if self.respond_to?(attr_name)
          self.send("#{attr_name}=", attr_value)
        end
      end
    end

    def self.api_url
      StreakClient.api_url('v2') + '/tasks'
    end

    def self.instance_api_url(task_key)
      StreakClient.api_url('v2') + "/tasks/#{task_key}"
    end

    def self.find(task_key)
      self.new(MultiJson.load(RestClient.get(self.instance_api_url(task_key))))
    end

    def self.delete(task_key)
      RestClient.delete(self.instance_api_url(task_key))
    end

    # params_hash example: {dueDate:1374271760000, text:newText}
    def update(params_hash)
      MultiJson.load(
        RestClient.post(
            Task.instance_api_url(key),
            params_hash.to_json,
            content_type: :json))
    end

    # # Assigns Users to the Task
    # #
    # # users_array example: [ { userKey: 'user1_key', email: 'user1@gmail.com' }, { ... }
    # # Send empty array to delete all assignees
    # def assign_users(users_array)
    #   response = MultiJson.load(
    #       RestClient.post(
    #           Task.instance_api_url(key),
    #           { assignedToSharingEntries: users_array }.to_json,
    #           content_type: :json))
    # end

    # Assigns Users to the Task by emails only
    def assign_users_by_email(email_array)
      users_array = email_array.map { |e| { email: e } }

      response = MultiJson.load(
          RestClient.post(
              Task.instance_api_url(key),
              { assignedToSharingEntries: users_array }.to_json,
              content_type: :json))
    end
  end

end
