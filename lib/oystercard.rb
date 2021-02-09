class Oystercard
	LIMIT = 90
	MIN = 1
	attr_reader :balance, :entry_station

	def initialize
		@balance = 0
	end

	def top_up(amount)
		fail "You cannot top up more than £#{LIMIT}" if amount + @balance > LIMIT
		@balance += amount
	end

	def in_journey?
		!!entry_station
	end

	def touch_in(station)
		fail "Balance not sufficient" if @balance < MIN
		@entry_station = station	
	end

	def touch_out
		deduct(MIN)
		@entry_station = nil
	end

	private
	def deduct(fare)
		@balance -= fare
	end

end
