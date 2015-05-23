require 'factory'
require 'repository_object/day_off'
require 'time_range'

shared_examples 'a day off repository' do
  it 'returns a repository object with the day off data on save' do
    day_off = Factory.day_off
    returned_day_off = described_class.new.save(day_off)

    expect(returned_day_off.id).not_to be_nil
    expect(returned_day_off.user_id).to eq(day_off.user_id)
    expect(returned_day_off.date).to eq(day_off.date)
    expect(returned_day_off.range.description).to eq(day_off.range.description)
    expect(returned_day_off.category).to eq(day_off.category)
    expect(returned_day_off.event_id).to eq(day_off.event_id)
    expect(returned_day_off.url).to eq(day_off.url)
  end

  it 'finds by user id' do
    day_off_repository = described_class.new
    day_off = Factory.day_off
    day_off_repository.save(day_off).user_id

    retrieved_day_off = day_off_repository.find_by_user_id(day_off.user_id).first
    expect(retrieved_day_off.id).not_to be_nil
    expect(retrieved_day_off.date).to eq(day_off.date)
    expect(retrieved_day_off.range.description).to eq(day_off.range.description)
    expect(retrieved_day_off.category).to eq(day_off.category)
    expect(retrieved_day_off.event_id).to eq(day_off.event_id)
    expect(retrieved_day_off.url).to eq(day_off.url)
  end

  it 'finds by id' do
    day_off_repository = described_class.new
    day_off = Factory.day_off
    id = day_off_repository.save(day_off).id

    retrieved_day_off = day_off_repository.find(id)
    expect(retrieved_day_off.user_id).to eq(day_off.user_id)
    expect(retrieved_day_off.date).to eq(day_off.date)
    expect(retrieved_day_off.range.description).to eq(day_off.range.description)
    expect(retrieved_day_off.category).to eq(day_off.category)
    expect(retrieved_day_off.event_id).to eq(day_off.event_id)
    expect(retrieved_day_off.url).to eq(day_off.url)
  end

  it 'destroys days off by event id' do
    day_off_repository = described_class.new
    day_off = day_off_repository.save(Factory.day_off)

    expect(day_off_repository.find_by_user_id(day_off.user_id).count).to eq(1)
    day_off_repository.destroy_by_event_id(day_off.event_id)

    expect(day_off_repository.find_by_user_id(day_off.user_id).count).to eq(0)
  end
end
