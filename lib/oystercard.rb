class Oystercard
	LIMIT = 90
	MIN = 1
	attr_reader :balance

	def initialize
		@balance = 0
	end

	def top_up(amount)
		fail "You cannot top up more than £#{LIMIT}" if amount + @balance > LIMIT
		@balance += amount
	end

	def in_journey?
		@journey
	end

	def touch_in
		fail "Balance not sufficient" if @balance < MIN
		@journey = true
	end

	def touch_out
		deduct(MIN)
		@journey = false
	end

	private
	def deduct(fare)
		@balance -= fare
	end

end
