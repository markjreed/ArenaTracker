class Server < ActiveRecord::Base
  def translated_name
    return translation || name.downcase.gsub(/\s+/,'-')
  end
end
