class Journey
  MIN_FARE = 1
  MAX_FARE = 6
  attr_reader :entry_station, :exit_station

  def initialize
    @entry_station = []
    @exit_station = []
  end

  def incomplete?
    (@entry_station == [] && @exit_station != []) || (@entry_station != [] && @exit_station == [])
  end

  def start_journey(entry_station)
    @entry_station += [entry_station.name, entry_station.zone]
  end

  def end_journey(exit_station)
    @exit_station += [exit_station.name, exit_station.zone]
  end

  def fare
    incomplete? ? MAX_FARE : MIN_FARE
  end

end
