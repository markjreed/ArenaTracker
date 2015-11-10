class Server < ActiveRecord::Base
  has_many :players
  def translated_name
    return translation || name.downcase.gsub(/\s+/,'-')
  end
end
