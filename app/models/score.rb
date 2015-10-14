class Score < ActiveRecord::Base
  belongs_to :Player
  belongs_to :Match
end
