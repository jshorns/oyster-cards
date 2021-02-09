require 'oystercard'

describe Oystercard do
	let (:max) { Oystercard::LIMIT }
	let (:min) { Oystercard::MIN}
	let (:station) { double :station }

	describe '#initialize' do
		it 'should have a default balance of zero' do
			expect(subject.balance).to eq(0)
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
		it 'prevents touch in' do
			expect{ subject.touch_in(station) }.to raise_error "Balance not sufficient"
		end

		it 'stores the entry station' do
			subject.top_up(max)
			subject.touch_in(station)
			expect(subject.entry_station).to eq station
		end

  end

	describe '#touch_out' do
		it 'can touch out' do
			subject.top_up(max)
			subject.touch_in(station)
			expect { subject.touch_out }.to change{ subject.balance }.by(- min)
			subject.touch_out
			expect(subject.entry_station).not_to eq station
		end
	end
end
