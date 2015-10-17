class Player < ActiveRecord::Base

  filterrific(
    default_filter_params: { sorted_by: 'name_asc' },
    available_filters: [
      :sorted_by,
      :with_class_name
    ]
  )

  scope(:sorted_by, lambda do |sort_key|
    direction = sort_key =~ /desc$/ ? 'desc' : 'asc'
    case sort_key.to_s 
    when /^name_/
      order "players.name #{direction}"
    else
      raise ArgumentError, "Invalid sort option: #{ sort_option.inspect }"
    end
  end)

  scope :with_class_name, lambda { |class_names|
    where class_name: [*class_names]
  }

end
