require "time"

class API
  @@reservations = {} 

  def self.load_reservations()
    config_file = File.read(File.join(File.dirname(__FILE__), "../resources.json"))
    resources = JSON.parse(config_file)
    resources["resources"].each do |i|
      @@reservations[i] = {}
    end
  end 

  def self.create_reservation(data, resource)
    d = {
      "reservation_username" => data["reservation_username"],
      "reservation_date" => Time.now.to_i
    }
    @@reservations[resource] = d
  end

  def self.delete_reservation(data, resource)
    @@reservations[resource] = {}
  end


  def self.list_reservations()
    return @@reservations
  end
end
