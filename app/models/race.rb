class Race < ApplicationRecord
  def self.total_republican_house
    Race.where(house: true).where("leader = ?", "Republican").count
  end

  def self.total_republican_senate
    Race.where(house: false).where("leader = ?", "Republican").count
  end

  def self.total_democrat_house
    Race.where(house: true).where("leader = ?", "Democrat").count
  end

  def self.total_democrat_senate
    Race.where(house: false).where("leader = ?", "Democrat").count
  end
end
