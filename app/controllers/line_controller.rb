class LineController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  # def client
  #   @client ||= Line::Bot::Client.new { |config|
  #     config.channel_id = ENV["LINE_CHANNEL_ID"]
  #     config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
  #     config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  #   }
  # end

  def create
    p "i am in the method"
    body = request.body.read
    p body
    user_id = ENV['DC_LINE_ID']
    messages = ['hello', 'world']

    Line::PushMessage.call(user_id, messages)

    render json: { status: 'ok' }, Status: :ok
  end
end
