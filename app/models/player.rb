class Player < ActiveRecord::Base
  PVP_URL_PREFIX = 'http://eu.battle.net/wow/en/character/'

  has_many :scores
  has_many :personal_match_infos
  has_many :matches, through: :scores
  has_many :match_talent_glyph_selections
  belongs_to :server

  def server_name
    has_attribute?(:server_name) ? self[:server_name] : server.name
  end

  filterrific(
    default_filter_params: { sorted_by: 'name_asc' },
    available_filters: [
      :sorted_by,
      :with_class_name,
      :with_spec_name,
      :with_teammate
    ]
  )

  scope :sorted_by, lambda { |sort_key|
    direction = sort_key =~ /desc$/ ? 'desc' : 'asc'
    case sort_key.to_s
    when /^name_/
      order "players.name #{direction}"
    when /^class_name_/
      order "players.class_name #{direction}"
    when /^server_name_/
      order "players.server_name #{direction}"
    when /^spec_name_/
      order "players.spec_name #{direction}"
    else
      raise ArgumentError, "Invalid sort option: #{ sort_key.inspect }"
    end
  }

  scope :with_class_name, lambda { |class_names|
    where class_name: [*class_names]
  }

  scope :with_spec_name, lambda { |spec_names|
    where spec_name: [*spec_names]
  }

  scope :with_match, lambda { |matches|
    where match: [*matches]
  }

  scope :with_teammate, lambda { |players|
    where id: [*players].inject([]) { |a,p| 
        Score.where(player: p).inject(a) {|a,s| 
          a += Score.where(match: s.match, player_faction: s.player_faction).map{|s|s.player} 
        }
    }.uniq.map(&:id)
  }

  def pvp_url
    File.join PVP_URL_PREFIX, server.translated_name, name, 'pvp#bgs'
  end

  def self.options_for_select
    order('LOWER(name)').map { |e| [e.name, e.id] }
  end

end
