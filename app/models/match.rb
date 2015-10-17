class Match < ActiveRecord::Base
  has_many :scores
  
  scope :with_player, lambda { |players|
      where(Player_id: [*players])
      }
      
  scope :options_for_sorted_by, lambda { |created|
      where(created_at: [*created])
      }
      
   filterrific(
    default_settings: { sorted_by: 'created_at_desc' },
    filter_names: [
      :sorted_by,
      :search_query,
      :with_player
    ]
  )      
end
