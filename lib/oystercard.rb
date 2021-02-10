class Oystercard
	LIMIT = 90
	MIN = 1
	attr_reader :balance, :entry_station, :exit_station, :journeys

	def initialize
		@balance = 0
		@journeys = {}
	end

	def top_up(amount)
		fail "You cannot top up more than £#{LIMIT}" if amount + @balance > LIMIT
		@balance += amount
	end

	def in_journey?
		!!entry_station
	end

	def touch_in(entry_station)
		fail "Balance not sufficient" if @balance < MIN
		@entry_station = entry_station
	end

	def touch_out(exit_station)
		deduct(MIN)
		@entry_station = nil
		@exit_station = exit_station
	end

	private
	def deduct(fare)
		@balance -= fare
	end

end
