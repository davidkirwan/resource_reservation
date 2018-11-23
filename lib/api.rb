require "time"
require "json"

class API
  @@reservations = {} 

  def self.load_reservations()
    config_file = File.read(File.join(File.dirname(__FILE__), "../resources.json"))
    @@reservations = JSON.parse(config_file)
  end 

  def self.write_reservations()
    config_file = File.open(File.join(File.dirname(__FILE__), "../resources.json"), "w")
    config_file.write(@@reservations.to_json)
    config_file.close
  end

  def self.create_reservation(data, resource)
    d = {
      "reservation_username" => data["reservation_username"],
      "reservation_date" => Time.now.to_i
    }
    @@reservations[resource] = d
    self.write_reservations()
  end

  def self.delete_reservation(data, resource)
    @@reservations[resource] = {}
    self.write_reservations()
  end

  def self.list_reservations()
    self.load_reservations()
    return @@reservations
  end
end
