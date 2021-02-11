require 'oyster_card'
require 'journey'

describe OysterCard do
	#edge case to be aware of; if the user touches in and touches out at the same station.
	let (:max) { OysterCard::LIMIT }
	let (:min) { OysterCard::MIN}
	let (:penalty_fare) { Journey::PENALTY_FARE }
	let (:test_balance) { 10 }
	let (:entry_station) { double(:station, :name => "Brixton", :zone => "Zone 2") }
	let (:exit_station) { double(:station, :name => "SevenSisters", :zone => "Zone 3") }

	describe '#initialize' do
		it 'should have a default balance of zero' do
			expect(subject.balance).to eq(0)
		end
		it 'should have no journey history' do
			expect(subject.journeys).to eq []
		end
		it 'should have an empty journey as the current_journey' do
			expect(subject.current_journey).to be_instance_of Journey
		end
	end

	describe '#top_up' do
		it { is_expected.to respond_to(:top_up).with(1).argument }

		it "raises an error when limit is exceeded" do
			subject.top_up(max)
			expect{ subject.top_up 1 }.to raise_error("You cannot top up more than £#{max}")
		end
	end

	describe '#in_journey?' do
		it { is_expected.to respond_to(:in_journey?) }

		it "initially isn't on a journey" do
			expect(subject).not_to be_in_journey
		end
	end

	describe '#touch_in' do
		context 'card has balance of 0' do
			it 'prevents touch in when card has below MIN' do
				expect{ subject.touch_in(entry_station) }.to raise_error "Balance not sufficient"
			end
		end
		context 'card has been topped up with test_balance' do
			before(:each) { subject.top_up(test_balance) }
			it 'has stored the entry station' do
				expect { subject.touch_in(entry_station) }.to change { subject.current_journey.entry_station }.to [entry_station.name, entry_station.zone]
			end
			context 'card was already touched_in once, aka never touched out' do
				before(:each) { subject.touch_in(entry_station) }
				it 'user is charged penalty fare for never touching out' do
					expect { subject.touch_in(exit_station) }.to change(subject, :balance).by -penalty_fare
				end
				it 'current_journey now contains the new journey with station as start' do
					expect { subject.touch_in(exit_station) }.to change { subject.current_journey.entry_station }.to [exit_station.name, exit_station.zone]
				end
				it 'touching in stores the previously incomplete journey to journey history' do
					expect { subject.touch_in(exit_station) }.to change { subject.journeys.length }.by 1
				end
				it 'stored journey shows as incomplete' do
					subject.touch_in(exit_station)
					expect(subject.journeys.last.entry_station).to eq [entry_station.name, entry_station.zone]
					expect(subject.journeys.last.exit_station).to eq []
				end
			end
		end
	end

	describe '#touch_out' do
		context 'card has balance of test_balance and was previously touched in' do
			before(:each) do
				subject.top_up(test_balance)
				subject.touch_in(entry_station)
			end
			it 'stores completed journey to journey history' do
				expect { subject.touch_out(exit_station) }.to change { subject.journeys.length }.by 1
			end
			it 'deducts minimum charge from card balance' do
				expect { subject.touch_out(exit_station) }.to change(subject, :balance).by -min
			end
			it 'changes value of @current_journey to a new journey' do
				subject.touch_out(exit_station)
				expect(subject.current_journey.entry_station).to eq []
				expect(subject.current_journey.exit_station).to eq []
			end
		end
		context 'card has balance of test_balance but had not previously been touched in' do
			before(:each) do
				subject.top_up(test_balance)
			end
			it 'adds journey to journey history' do
				expect { subject.touch_out(exit_station) }.to change { subject.journeys.length }.by 1
			end
			it 'stored journey shows as incomplete' do
				subject.touch_out(exit_station)
				expect(subject.journeys.last.entry_station).to eq []
				expect(subject.journeys.last.exit_station).to eq [exit_station.name, exit_station.zone]
			end
			it 'deducts penalty fare from card balance' do
				expect { subject.touch_out(exit_station) }.to change(subject, :balance).by -penalty_fare
			end
			it 'changes value of @current_journey to a new journey' do
				subject.touch_out(exit_station)
				expect(subject.current_journey.entry_station).to eq []
			end
		end
	end
end
