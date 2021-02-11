require 'journey'

describe Journey do
  let (:max_fare) { Journey::MAX_FARE }
  let (:min_fare) { Journey::MIN_FARE }
  let (:station) { double(:station, :name => "Brixton", :zone => "Zone 2") }
  let (:station2) { double(:station, :name => "Seven Sisters", :zone => "Zone 3") }

  it { is_expected.to respond_to :entry_station }
  it { is_expected.to respond_to :exit_station }

  describe 'when new' do
    it 'should have no entry station' do
      expect(subject.entry_station).to eq []
    end
    it 'should have no exit station' do
      expect(subject.exit_station).to eq []
    end
    it '#incomplete should return false' do
      expect(subject.incomplete?).to be false
    end
  end

  describe '#start_journey' do
    it 'changes value of entry station' do
      expect { subject.start_journey(station) }.to change(subject, :entry_station).to([station.name, station.zone])
    end
  end

  describe '#end_journey' do
    it 'changes value of entry station' do
      expect { subject.end_journey(station) }.to change(subject, :exit_station).to([station.name, station.zone])
    end
  end

  context 'when there is an entry station but no exit station' do
    before(:each) { subject.instance_variable_set(:@entry_station, [station.name, station.zone]) }
      it '#incomplete? returns true' do
        expect(subject.incomplete?).to be true
      end
      it '#fare returns maximum fare' do
        expect(subject.fare).to eq max_fare
      end
  end

  context 'when there is an exit station but no entry station' do
    before(:each) { subject.instance_variable_set(:@exit_station, [station.name, station.zone]) }
      it '#incomplete? returns true' do
        expect(subject.incomplete?).to be true
      end
      it '#fare returns maximum fare' do
        expect(subject.fare).to eq max_fare
      end
  end

  context 'when there is a complete journey' do
    before(:each) do
      subject.instance_variable_set(:@entry_station, [station.name, station.zone])
      subject.instance_variable_set(:@exit_station, [station2.name, station2.zone])
    end
    it '#incomplete? returns false' do
      expect(subject.incomplete?).to be false
    end
    it '#fare returns minimum fare' do
      expect(subject.fare).to eq min_fare
    end
  end

end
