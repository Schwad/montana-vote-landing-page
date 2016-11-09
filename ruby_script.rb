require 'mechanize'
require 'pry'
i = 26
hi = Mechanize.new
hi = hi.get('http://mtresults.totalvote.com/resultsSW.aspx?ID=4041&hashtags=Vote')
total_counts = Hash.new
while i < 151
  puts "i is at #{i}"
  begin
    key = hi.search('.wrapper-inside')[i].search('.display-results-box-a h1').text
    total_counts[key] = Hash.new
    total_counts[key]["district"] = hi.search('.wrapper-inside')[i].search('.display-results-box-a h1').text.match(/\s(\w+)$/)[1]
    total_counts[key]["first_name"] = hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-d h1')[0].text unless hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-d h1')[0].nil?
    total_counts[key]["first_party"] = hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-d h2')[0].text unless hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-d h2')[0].nil?
    total_counts[key]["second_name"] = hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-d h1')[1].text unless hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-d h1')[1].nil?
    total_counts[key]["second_party"] = hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-d h2')[1].text unless hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-d h2')[1].nil?
    total_counts[key]["first_count"] = hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-f h1')[0].text unless hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-f h1')[0].nil?
    total_counts[key]["second_count"] = hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-f h1')[1].text unless hi.search('.wrapper-inside')[i].search('.section').search('.display-results-box-f h1')[1].nil?
    if hi.search('.wrapper-inside')[i].search('.display-results-box-a h1').nil?
      total_counts[key]["House"] = "SENATE"
    else
      total_counts[key]["HOUSE"] = "HOUSE"
    end

    if total_counts[key]["first_count"].to_i > total_counts[key]["second_count"].to_i
      total_counts[key]["leader"] = total_counts[key]["first_party"]
    elsif total_counts[key]["first_count"].to_i < total_counts[key]["second_count"].to_i
      total_counts[key]["leader"] = total_counts[key]["second_party"]
    else
      total_counts[key]["leader"] = "Neither"
    end
    i += 1
  rescue => e
    binding.pry
  end
end
puts "yo"
