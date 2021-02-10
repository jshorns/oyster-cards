require './lib/station'
require './lib/journey'

class Oystercard
	LIMIT = 90
	MIN = 1
	attr_reader :balance, :entry_station, :exit_station, :journeys

	def initialize
		@balance = 0
		@current_journey = Journey.new
		@journeys = []
	end

	def top_up(amount)
		fail "You cannot top up more than £#{LIMIT}" if amount + @balance > LIMIT
		@balance += amount
	end

	def in_journey?
		@journeys.last[:entry_station] != []
	end

	def touch_in(entry_station)
		fail "Balance not sufficient" if @balance < MIN
		deduct(@current_journey.fare) if @current_journey.entry_station != []
		@current_journey.start_journey(entry_station)
#		@journeys.last[:entry_station] += [entry_station.name, entry_station.zone]
	end

	def touch_out(exit_station)
		@current_journey.end_journey(exit_station)
	#	@journeys.last[:exit_station] += [exit_station.name, exit_station.zone]
		@journeys << @current_journey
		@current_journey = Journey.new
		deduct(MIN)
	end

	private
	def deduct(fare)
		@balance -= fare
	end

	def add_empty_journey
		@journeys << { entry_station: [], exit_station: [] }
	end

end
