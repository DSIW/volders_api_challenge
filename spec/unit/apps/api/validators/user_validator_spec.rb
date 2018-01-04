describe Api::Validators::UserValidator do
  let(:validator) { described_class.new(user) }
  let(:user) { double(User, to_h: attributes) }

  describe "#validate" do
    describe "with valid user" do
      let(:attributes) { {full_name: 'Max Mustermann', email: 'max@mustermann.de', password: 'password'} }

      it 'succeeds' do
        expect(validator.validate).to be_success
      end
    end

    describe "with user with empty full_name" do
      let(:attributes) { {full_name: '', email: 'max@mustermann.de', password: 'password'} }

      it 'fails' do
        expect(validator.validate).not_to be_success
      end

      it 'sets message "should not be empty"' do
        expect(validator.validate.messages.fetch(:full_name)).to eq ['should not be empty']
      end
    end

    describe "with user with empty email" do
      let(:attributes) { {full_name: 'Max Mustermann', email: '', password: 'password'} }

      it 'fails' do
        expect(validator.validate).not_to be_success
      end

      it 'sets message "should not be empty"' do
        expect(validator.validate.messages.fetch(:email)).to eq ['should not be empty']
      end
    end

    describe "with user with empty password" do
      let(:attributes) { {full_name: 'Max Mustermann', email: 'max@mustermann.de', password: ''} }

      it 'fails' do
        expect(validator.validate).not_to be_success
      end

      it 'sets message "should not be empty"' do
        expect(validator.validate.messages.fetch(:password)).to eq ['should not be empty']
      end
    end
  end
end
