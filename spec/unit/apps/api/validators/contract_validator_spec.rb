describe Api::Validators::ContractValidator do
  let(:validator) { described_class.new(contract) }
  let(:contract) { double(Contract, to_h: attributes) }
  let(:start_time) { '2018-01-01T00:00:00Z' }
  let(:end_time) { '2019-01-01T00:00:00Z' }

  describe "#validate" do
    describe "with valid contract" do
      let(:attributes) { {vendor: 'Vodafone', starts_on: start_time, ends_on: end_time} }

      it 'succeeds' do
        expect(validator.validate).to be_success
      end
    end

    describe "with empty vendor" do
      let(:attributes) { {vendor: '', starts_on: start_time, ends_on: end_time} }

      it 'fails' do
        expect(validator.validate).not_to be_success
      end

      it 'sets message "should not be empty"' do
        expect(validator.validate.messages.fetch(:vendor)).to eq ['should not be empty']
      end
    end

    describe "with empty starts_on" do
      let(:attributes) { {vendor: 'Vodafone', starts_on: '', ends_on: end_time} }

      it 'fails' do
        expect(validator.validate).not_to be_success
      end

      it 'sets message "should not be empty"' do
        expect(validator.validate.messages.fetch(:starts_on)).to eq ['should not be empty']
      end
    end

    describe "with empty ends_on" do
      let(:attributes) { {vendor: 'Vodafone', starts_on: start_time, ends_on: ''} }

      it 'fails' do
        expect(validator.validate).not_to be_success
      end

      it 'sets message "should not be empty"' do
        expect(validator.validate.messages.fetch(:ends_on)).to eq ['should not be empty']
      end
    end

    describe "with ends_on < starts_on" do
      let(:attributes) { {vendor: 'Vodafone', starts_on: end_time, ends_on: start_time} }

      it 'fails' do
        expect(validator.validate).not_to be_success
      end

      it 'sets message "Ends on should be greater than Starts on"' do
        message = 'Ends on should be greater than Starts on'
        expect(validator.validate.messages.fetch(:ends_on)).to eq [message]
      end
    end

    describe "with ends_on = starts_on" do
      let(:attributes) { {vendor: 'Vodafone', starts_on: start_time, ends_on: start_time} }

      it 'fails' do
        expect(validator.validate).not_to be_success
      end

      it 'sets message "Ends on should be greater than Starts on"' do
        message = 'Ends on should be greater than Starts on'
        expect(validator.validate.messages.fetch(:ends_on)).to eq [message]
      end
    end
  end
end
