module Line
  class PushMessage < ApplicationService

    def initialize(user_id, messages)
      @user_id = user_id
      @messages = messages
      super()
    end

    def call
      # endpoint URL
      endpoint = 'https://api.line.me/v2/bot/message/push'

      # create header
      headers = {
        "Content-Type": 'application/json',
        "Authorization": "Bearer #{ENV['LINE_CHANNEL_TOKEN']}"
        # 'X-Line-Retry-Key' => "#{UUID}" ## Optional
      }

      # create payload
      payload = {
        "to": @user_id,
        "messages": build_messages(@messages)
      }.to_json

      p "=========Validate this========"
      p payload
      # POST request
      response = RestClient.post(endpoint, payload, headers)

      p response
    end

    private

    def build_messages(messages)
      messages.map! do |message|
        {
          "type": 'text',
          "text": message
        }
      end
    end
  end
end
