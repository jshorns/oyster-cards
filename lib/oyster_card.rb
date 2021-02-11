require './lib/station'
require './lib/journey'

class OysterCard
	LIMIT = 90
	MIN = 1
	attr_reader :balance, :journeys, :current_journey

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
		@current_journey.incomplete?
	end

	def incomplete_journey
			deduct(@current_journey.fare)
			@journeys << @current_journey
			@current_journey = Journey.new
	end

	def touch_in(entry_station)
		fail "Balance not sufficient" if @balance < MIN
		incomplete_journey if @current_journey.incomplete?
		@current_journey.start_journey(entry_station)
#		@journeys.last[:entry_station] += [entry_station.name, entry_station.zone]
	end

	def touch_out(exit_station)
		@current_journey.end_journey(exit_station)
		if @current_journey.incomplete?
			incomplete_journey
		else
			deduct(@current_journey.fare)
	#	@journeys.last[:exit_station] += [exit_station.name, exit_station.zone]
			@journeys << @current_journey
			@current_journey = Journey.new
		end
	end

	private
	def deduct(fare)
		@balance -= fare
	end

	def add_empty_journey
		@journeys << { entry_station: [], exit_station: [] }
	end

end
