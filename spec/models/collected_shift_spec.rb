require 'rails_helper'

RSpec.describe CollectedShift, type: :model do
  it 'has valid factory' do
    collected_shift =  build(:collected_shift)
    expect(collected_shift).to be_valid
  end
  
  it 'is not valid without user_id' do
    collected_shift =  build(:collected_shift, user_id: nil)
    expect(collected_shift).not_to be_valid
  end
  
  it 'is not valid without started_at' do
    collected_shift =  build(:collected_shift, started_at: nil)
    expect(collected_shift).not_to be_valid
  end
  
  it 'is not valid without finished_at' do
    collected_shift =  build(:collected_shift, finished_at: nil)
    expect(collected_shift).not_to be_valid
  end
  
  it 'is not valid with started_at before today' do
    collected_shift =  build(:collected_shift, started_at: Time.current - 1.day)
    expect(collected_shift).not_to be_valid
  end
  
  it 'is not valid with finished_at before started_at' do
    collected_shift =  build(:collected_shift, started_at: Time.current + 1.day, finished_at: Time.current)
    expect(collected_shift).not_to be_valid
  end
end
