require 'rails_helper'

RSpec.describe Tin, type: :model do
  describe 'Existence validations' do
    subject { Tin.new(country: country, number: number) }

    context 'when country is missing' do
      let(:country) { nil }
      let(:number) { '123456789' }

      it 'record is invalid' do
        expect(subject).not_to be_valid
      end

      # it 'adds a country error message' do
      #   expect(subject).to include('A country must be specified on the request. Please try again.')
      # end
    end

    context 'when number is missing' do
      let(:country) { 'CA' }
      let(:number) { nil }

      it 'expects record to be invalid' do
        expect(subject).not_to be_valid
      end

      # it 'adds a number error message' do
      #   expect(subject.errors.full_messages).to include('A number must be specified on the request. Please try again.')
      # end
    end
  end

  describe 'Country validations' do
    subject { build(:tin, :au_abn) }

    context 'with valid ABN' do
      it 'correctly validates the record' do
        subject.valid?
        expect(subject.valid).to be true
      end

      it 'sets tin_type correctly' do
        subject.valid?
        expect(subject.tin_type).to eq('au_abn')
      end

      it 'sets formatted tin correctly' do
        subject.valid?
        expect(subject.formatted_tin).to eq('10 120 000 004')
      end
    end
  end
end
