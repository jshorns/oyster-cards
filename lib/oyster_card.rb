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
		max_balance_error(amount)
		@balance += amount
	end

	def in_journey?
		@current_journey.incomplete?
	end

	def touch_in(entry_station)
		insufficient_funds
		complete_journey if in_journey?
		@current_journey.start_journey(entry_station)
	end

	def touch_out(exit_station)
		@current_journey.end_journey(exit_station)
		complete_journey
	end

	private
	def deduct(fare)
		@balance -= fare
	end

	def complete_journey
			deduct(@current_journey.fare)
			@journeys << @current_journey
			@current_journey = Journey.new
	end

	def max_balance_error(amount)
		fail "You cannot top up beyond £#{LIMIT}" if amount + @balance > LIMIT
	end

	def insufficient_funds
		fail "Balance not sufficient" if @balance < MIN
	end

end
