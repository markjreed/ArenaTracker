class Match < ActiveRecord::Base
  has_many :scores
  has_many :personal_match_infos
  has_many :players, through: :scores
  has_many :match_talent_glyph_selections

  # any methods def'ed here become instance methods on Match objects
  def mmrs
     mmr_list.nil? ? [] : mmr_list.split(/,/).map(&:to_i)
  end

  def mmr_avg
     mmrs.instance_eval { empty? ? 0 : reduce(0,:+) / size.to_f.round }
  end

  def length
    match_end - match_start
  end

  filterrific(
    default_filter_params: { sorted_by: 'date_time_desc' },
    available_filters: [
      :sorted_by,
      :with_player,
      :mmr_above
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

  scope :with_player, lambda { |players|
    where player: [*players]
  }

  scope :mmr_above, lambda { |mmr|
    select { |match| match.mmr_avg > mmr } 
  }
end
