require 'range'

describe Range do
  context 'when range is partial day' do
    before do
      @range = Range.new(
        description: Range::MORNING,
        start_time: '09:00:00',
        end_time: '13:00:00')
    end

    describe '#start_time' do
      it 'returns the start time with time zone offset' do
        expect(@range.start_time).to eq('09:00:00-06:00')
      end
    end

    describe '#end_time' do
      it 'returns the end time with time zone offset' do
        expect(@range.end_time).to eq('13:00:00-06:00')
      end
    end

    describe '#all_day?' do
      it 'returns false' do
        expect(@range.all_day?).to be false
      end
    end

    describe '#time_value' do
      it 'returns 0.5' do
        expect(@range.time_value).to eq(0.5)
      end
    end
  end

  context 'when range is full day' do
    before do
      @range = Range.new(description: Range::ALL_DAY)
    end

    describe '#start_time' do
      it 'raises a DayOffRangeError' do
        expect { @range.start_time }.to raise_error DayOffRangeError
      end
    end

    describe '#end_time' do
      it 'raises a DayOffRangeError' do
        expect { @range.end_time }.to raise_error DayOffRangeError
      end
    end

    describe '#all_day?' do
      it 'returns true' do
        expect(@range.all_day?).to be true
      end
    end

    describe '#time_value' do
      it 'returns 1' do
        expect(@range.time_value).to eq(1)
      end
    end
  end
end
