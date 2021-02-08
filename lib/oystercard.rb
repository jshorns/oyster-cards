class Oystercard
	LIMIT = 90
	attr_reader :balance

	def initialize
		@balance = 0
	end

	def top_up(amount)
		fail "You cannot top up more than £#{LIMIT}" if amount + @balance > LIMIT
		@balance += amount
	end

end
