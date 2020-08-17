require 'rails_helper'

RSpec.describe 'CreatedShifts', type: :model do
  describe 'validation' do
    let(:created_shift) { build(:created_shift, started_at: start, finished_at: finish) }

    shared_examples 'created_shift' do
      it 'is invalid' do
        expect(created_shift).not_to be_valid
      end
    end

    context 'with started_at and finished_at' do
      let(:start) { Time.current.tomorrow }
      let(:finish) { Time.current.tomorrow.since(1.hour) }

      it 'is valid' do
        expect(created_shift).to be_valid
      end
    end

    context 'without started_at' do
      let(:start) { nil }
      let(:finish) { Time.current.tomorrow.since(1.hour) }

      it_behaves_like 'created_shift'
    end

    context 'without finished_at' do
      let(:start) { Time.current.tomorrow }
      let(:finish) { nil }

      it_behaves_like 'created_shift'
    end

    context 'finished_at before started_at' do
      let(:start) { Time.current.tomorrow.since(1.day) }
      let(:finish) { Time.current.tomorrow }

      it_behaves_like 'created_shift'
    end

    context 'over 1 day from started_at to finished_at' do
      let(:start) { Time.current.tomorrow }
      let(:finish) { Time.current.since(3.days) }

      it_behaves_like 'created_shift'
    end

    context 'created_shift before today' do
      let(:start) { Time.current.yesterday }
      let(:finish) { Time.current.yesterday.since(1.hour) }

      it_behaves_like 'created_shift'
    end

    context 'associated collected_shift is determined' do
      let(:collected_shift) { create(:determined_shift) }
      let!(:created_shift) { build(:created_shift, collected_shift: collected_shift) }

      it_behaves_like 'created_shift'
    end
  end

  describe 'scope' do
    context 'user_created_shifts' do
      let(:user) { create(:user) }
      let(:collected_shift) { create(:non_determined, user: user) }
      let!(:created_shift) { create(:created_shift, collected_shift: collected_shift) }

      it 'indicates correct created_shift' do
        expect(CreatedShift.user_created_shifts([user.id]).take).to eq created_shift
      end
    end
  end

  describe 'callback' do
    context 'after create' do
      let(:created_shift) { build(:created_shift, collected_shift: collected_shift) }
      let(:collected_shift) { create(:non_determined) }

      it 'updates is_determine of collected_shift to true' do
        expect(created_shift.collected_shift.is_determined).to eq false

        created_shift.save
        expect(created_shift.collected_shift.is_determined).to eq true
      end
    end

    context 'after destroy' do
      let(:created_shift) { create(:created_shift, collected_shift: collected_shift) }
      let(:collected_shift) { create(:non_determined) }

      it 'downdate is_determine of collected_shift to false' do
        expect(created_shift.collected_shift.is_determined).to eq true

        created_shift.destroy
        expect(collected_shift.is_determined).to eq false
      end
    end
  end
end
