require 'oystercard'

describe Oystercard do
	let (:max) { Oystercard::LIMIT }
	let (:min) { Oystercard::MIN}
	let (:entry_station) { double(:station, :name => "Brixton", :zone => "Zone 3") }
	let (:exit_station) { double(:station, :name => "SevenSisters", :zone => "Zone 3") }

	describe '#initialize' do
		it 'should have a default balance of zero' do
			expect(subject.balance).to eq(0)
		end

		it 'has a list of empty journeys by default' do
			expect(subject.journeys).to eq [{ entry_station: [], exit_station: [] } ]
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
			expect{ subject.touch_in(entry_station) }.to raise_error "Balance not sufficient"
		end

		it 'stores the entry station' do
			subject.top_up(max)
			subject.touch_in(entry_station)
			expect(subject.journeys.last[:entry_station]).to eq [entry_station.name, entry_station.zone]
		end

  end

	describe '#touch_out' do
		it 'can touch out' do
			subject.top_up(max)
			subject.touch_in(entry_station)
			expect { subject.touch_out(exit_station) }.to change{subject.balance}.by(- min)
			subject.touch_out(exit_station)
			expect(subject.journeys).to include({entry_station: [entry_station.name, entry_station.zone], exit_station: [exit_station.name, exit_station.zone]})
		end

		it 'checks that touching in and out stores one journey' do
			subject.top_up(max)
			subject.touch_in(entry_station)
			expect{ subject.touch_out(exit_station) }.to change { subject.journeys.length}.by(1)
		end
	end
end
