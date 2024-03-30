module Fireworks
  class Chat < ApplicationService
    def initialize(user_message)
      @user_message = user_message
      @url = 'https://api.fireworks.ai/inference/v1/chat/completions'
      @headers = {
        'Authorization': "Bearer #{ENV['FIREWORKS_TOKEN']}",
        'Content-Type': 'application/json'
      }
      super()
    end

    def call
      prompt = <<~PROMPT
        You are a marketing expert for writing amazing descriptions for venue rental spaces.

        You are receiving a user's prompt looking for a venue with a specificiation.

        You are receiving a list of 3 JSON locations. For each of the location change the attribute: room_tagline, room_title, room_description an create a new JSON.

        For the room_tagline, you want to write in english a catchy tagline that descript the location will fit the user's request
        For the room_title, you want to write in english a catchy title that descript the location will fit the user's request
        For the room_description, you want to write a English description of the loaction, it should be attention-grabbing and contains all the keywords that would make the user want to book this location. It should contain four paragraphs. The total reading time should be around 3-5 mins.
        The description should be in English. In the DESCRIPTION please include :
        1) the description of the venue;
        2) the equipment available of the venue space;
        3) how the equipment benefit the target audience and how they intent to use the space
        4) the convenience of the location.

        You should return me a list of location in a JSON like the example below:
        [{room_tagline: "$new_tagline, room_title: "$new_title", room_description: "$new_description, ...[other attributes]},{room_tagline: "$new_tagline, room_title: "$new_title", room_description: "$new_description, ...[other attributes]}]

        Before you response. make sure your response is an array and nothing else
        -------

      PROMPT
      json_data = <<~DATA
        [{"room_id": "5770176227",
        "end_at": "2024-01-09 16:30",
        "square_meter": "10",
        "town": "\\u6d5c\\u677e\\u753a",
        "prefecture": "\\u6771\\u4eac\\u90fd",
        "usage": "\\u4f1a\\u8b70\\u30fb\\u6253\\u3061\\u5408\\u308f\\u305b",
        "num_of_people": "4",
        "lon": "139.754894",
        "ward": "\\u6e2f\\u533a",
        "start_at": "2024-01-09 14:00",
        "room_tagline": "H\\u00b9T\\u6d5c\\u677e\\u753a\\uff08\\u5927\\u9580\\u99c5\\u524d\\uff09\\u4f1a\\u8b70\\u5ba4 02(4\\u540d)",
        "room_title": "H\\u00b9T\\u6d5c\\u677e\\u753a\\uff08\\u5927\\u9580\\u99c5\\u524d\\uff09\\uff08\\u30b5\\u30c6\\u30e9\\u30a4\\u30c8\\u578b\\u30b7\\u30a7\\u30a2\\u30aa\\u30d5\\u30a3\\u30b9\\uff09\\u4f1a\\u8b70\\u5ba4'02(4\\u540d)",
        "booking_id": "135014043",
        "review_point": "4",
        "rooms_capacity": "4",
        "user_id": "24156272766",
        "room_description": "\\u65bd\\u9320\\u53ef\\u80fd\\u306a\\u5b8c\\u5168\\u500b\\u5ba4\\u3067\\u3059\\u3002\\n\\u30e2\\u30cb\\u30bf\\u30fc\\u5b8c\\u5099\\u3067\\u30b2\\u30b9\\u30c8\\u306e\\u3054\\u62db\\u5f85\\u3082\\u53ef\\u80fd\\u3067\\u3059\\u3002\\n\\u5bfe\\u9762\\u3067\\u306e\\u6253\\u3061\\u5408\\u308f\\u305b\\u3084WEB\\u4f1a\\u8b70\\u306b\\u3054\\u5229\\u7528\\u304f\\u3060\\u3055\\u3044\\u3002\\n\\u203b\\u5229\\u7528\\u4eba\\u6570\\u306b\\u3054\\u6ce8\\u610f\\u304f\\u3060\\u3055\\u3044\\u3002\\n\\nH\\u00b9T\\u306f\\u5168\\u5e2d\\u3067\\u4f1a\\u8a71\\u30fb\\u901a\\u8a71\\u30fbWEB\\u4f1a\\u8b70\\u53ef\\u80fd\\u3067\\u3059\\u3002\\n\\n\\u203b\\u6cd5\\u4eba\\u3067\\u306e\\u3054\\u5229\\u7528\\u306e\\u5834\\u5408\\u306f\\u3001\\u4e88\\u7d04\\u624b\\u7d9a\\u304d\\u306e\\u969b\\u306b\\u3001\\u6240\\u5c5e\\u3055\\u308c\\u3066\\u3044\\u308b\\u6b63\\u5f0f\\u306a\\u4f1a\\u793e\\u540d\\u3084\\u56e3\\u4f53\\u540d\\u306e\\u5165\\u529b\\u3092\\u304a\\u9858\\u3044\\u81f4\\u3057\\u307e\\u3059\\u3002",
        "booked_at": "2023-12-30 14:14",
        "room_url": "https://www.instabase.jp/space/5770176227",
        "lat": "35.656033"}]
      DATA
      # parsed_data = JSON.parse(json_data)
      prompt += json_data

      payload = {
        "model": "accounts/stability/models/stablelm-zephyr-3b",
        "max_tokens": 4000,
        "top_p": 1,
        "top_k": 40,
        "presence_penalty": 0,
        "frequency_penalty": 0,
        "temperature": 0.0,
        "messages": [
          {
            "role": "system",
            "content": prompt
          },
          {
            "role": "user",
            "content": "find me a place that fit 8 people for board games"
          }
        ],
        "stream": false
      }.to_json
      p @headers
      response = RestClient.post(@url, payload, headers=@headers)
      if response.code == 200
        data = JSON.parse(response.body)
        p data
        locations = data['choices'][0]['message']['content']
        if locations.match?(/```/)
          p "it matches"
          p locations = locations.match(/\[.*?\]/m)[0]
        end
        locations_json = JSON.parse(locations)
        p "=================="
        p "========Below is the location json=========="
        p locations_json
      else
        puts "Error: #{response.code} - #{response.body}"
      end
    end
  end
end
