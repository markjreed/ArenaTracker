class Match < ActiveRecord::Base
  has_many :scores
  has_many :players, through: :scores
  has_many :match_talent_glyph_selections
  
  filterrific(
    default_filter_params: { sorted_by: 'date_time_desc' },
    available_filters: [
      :sorted_by,
      :with_player            
    ]
  )
  
  scope :sorted_by, lambda { |sort_key|
    direction = sort_key =~ /desc$/ ? 'desc' : 'asc'
    case sort_key.to_s
    when /^name_/
      order "players.name #{direction}"
    when /^date_time_/
      order "matches.date_time #{direction}"
    else
      # raise ArgumentError, "Invalid sort option: #{ sort_option.inspect }"
      raise ArgumentError, "Invalid sort option: #{ sort_key.to_s }"
      
    end
  }
  
  scope :with_player, lambda { |player|
    where player: [*players]
  }
  
end
