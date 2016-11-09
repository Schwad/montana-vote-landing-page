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
        new_race.house = false
      else
        new_race.house = true
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
end
