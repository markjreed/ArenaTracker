class Player < ActiveRecord::Base


  
  filterrific(
    default_settings: { with_class_name: 'Druid' },
    available_filters: [
      :sorted_by,
      :search_query,
      :with_class_name
    ]
  )

  # Player class selection
  scope :with_class_name, lambda { |class_names|
    where(class_name: [*class_names])
  }  
  
  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^name_/
      # Simple sort on the created_at column.
      # Make sure to include the table name to avoid ambiguous column names.
      # Joining on other tables is quite common in Filterrific, and almost
      # every ActiveRecord table has a 'created_at' column.
      order("players.name #{ direction }")
    when /^class_name_/
      # Simple sort on the name colums
      order("LOWER(players.class_name) #{ direction }")
    when /^spec_name_/
      # This sorts by a student's country name, so we need to include
      # the country. We can't use JOIN since not all students might have
      # a country.
      order("LOWER(players.spec_name) #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }
  
  scope :search_query, lambda { |query|
    # Searches the students table on the 'first_name' and 'last_name' columns.
    # Matches using LIKE, automatically appends '%' to each term.
    # LIKE is case INsensitive with MySQL, however it is case
    # sensitive with PostGreSQL. To make it work in both worlds,
    # we downcase everything.
    return nil  if query.blank?

    # condition query, parse into individual keywords
    terms = query.downcase.split(/\s+/)

    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conds = 2
    where(
      terms.map { |term|
        "(LOWER(players.name) LIKE ? OR LOWER(players.class_name) LIKE ? OR LOWER(players.class_name) LIKE ?)"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }
  
  def self.options_for_select
    order('LOWER(class_name)').map { |e| [e.name, e.id] }
  end
  
  def self.options_for_sorted_by
    [
      ['Name (a-z)', 'name_asc'],
      ['Class name', 'class_name_asc'],
      ['Spec name', 'spec_name_asc']      
    ]
  end
  
end
