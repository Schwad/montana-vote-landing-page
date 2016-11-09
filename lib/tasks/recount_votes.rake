require 'rubygems'
require 'oauth'
require 'json'
require 'mechanize'

task recount_votes: :environment do

  i = 26
  hi = Mechanize.new
  hi = hi.get('http://mtresults.totalvote.com/resultsSW.aspx?ID=4041&hashtags=Vote')
  Race.destroy_all
  while i < 151
    puts "i is at #{i}"
    new_race = Race.new
    begin
      new_race.race_name = hi.search('.wrapper-inside')[i].search('.display-results-box-a h1').text.match(/\s(\w+)$/)[1]
      new_race.first_name = hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-d h1')[0].text unless hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-d h1')[0].nil?
      new_race.first_party = hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-d h2')[0].text unless hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-d h2')[0].nil?
      new_race.second_name = hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-d h1')[1].text unless hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-d h1')[1].nil?
      new_race.second_party = hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-d h2')[1].text unless hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-d h2')[1].nil?
      new_race.first_votes = hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-f h1')[0].text.to_i unless hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-f h1')[0].nil?
      new_race.second_votes = hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-f h1')[1].text.to_i unless hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-f h1')[1].nil?
      if hi.search('.wrapper-inside')[i].search('.display-results-box-a h1').text.match(/STATE SENATOR/).nil?
        new_race.house = true
      else
        new_race.house = false
      end

      if new_race.first_votes > new_race.second_votes
        new_race.leader = new_race.first_party
      elsif new_race.first_votes < new_race.second_votes
        new_race.leader = new_race.second_party
      else
        new_race.leader = "Neither"
      end
      new_race.save
      i += 1
    rescue => e
    end
  end
  woah = TotalCount.new
  woah.republican_senate = Race.where(leader: "Republican").where(house: false).count
  woah.republican_house = Race.where(leader: "Republican").where(house: true).count
  woah.democrat_senate = Race.where(leader: "Democrat").where(house: false).count
  woah.democrat_house = Race.where(leader: "Republican").where(house: true).count
  woah.save
  ["Rs currently holding #{woah.republican_senate}, Ds holding #{woah.democrat_senate} seats in the State Senate. http://montanavotes2016.herokuapp.com/ #mtpol", "Rs currently holding #{woah.republican_senate}, Ds holding #{woah.democrat_senate} seats in the MT House. http://montanavotes2016.herokuapp.com/ #mtpol"].each do |message_tweet|
    #Twitter api auths and tokens
    consumer_key = OAuth::Consumer.new(
      "9rwoU0y9CNvchqEk11p2lg6VQ",
      "XcKg7qVm4AKpwJgrhAyGWkfFbWjhwxKGnuosvJjU7Ygd0ALT2f")
    access_token = OAuth::Token.new(
      "2890208126-m7PPmDIsKzyUqeS48ls8adqADzYwEzsFUSkHhgZ",
      "97ZjjdSKI2udjgZjiYrQtsTyxNJHQY5kg3IVDsGRRK4hY")

    baseurl = "https://api.twitter.com"
    path    = "/1.1/statuses/update.json"
    address = URI("#{baseurl}#{path}")
    request = Net::HTTP::Post.new address.request_uri


    #Output tweets go here
    request.set_form_data(
      "status" => message_tweet,
    )

    # Set up HTTP.
    http             = Net::HTTP.new address.host, address.port
    http.use_ssl     = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    # Issue the request.
    request.oauth! http, consumer_key, access_token
    http.start
    response = http.request request

    # Parse and print the Tweet if the response code was 200
    tweet = nil
    if response.code == '200' then
      tweet = JSON.parse(response.body)
      puts "Successfully sent #{tweet["text"]}"
    else
      puts "Could not send the Tweet! " +
      "Code:#{response.code} Body:#{response.body}"
    end
  end
end
