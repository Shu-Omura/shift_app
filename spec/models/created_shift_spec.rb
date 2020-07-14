require 'rails_helper'

RSpec.describe CreatedShift, type: :model do
  it 'has valid factory' do
    created_shift = build(:created_shift)
    expect(created_shift).to be_valid
  end

  it 'is not valid without collected_shift_id' do
    created_shift = build(:created_shift, collected_shift_id: nil)
    expect(created_shift).not_to be_valid
  end

  it 'is not valid without started_at' do
    created_shift = build(:created_shift, started_at: nil)
    expect(created_shift).not_to be_valid
  end

  it 'is not valid without finished_at' do
    created_shift = build(:created_shift, finished_at: nil)
    expect(created_shift).not_to be_valid
  end

  it 'is not valid with started_at before today' do
    created_shift = build(:created_shift, started_at: Time.current - 1.day)
    expect(created_shift).not_to be_valid
  end

  it 'is not valid with finished_at before started_at' do
    created_shift = build(:created_shift, started_at: Time.current + 1.day, finished_at: Time.current)
    expect(created_shift).not_to be_valid
  end
end
