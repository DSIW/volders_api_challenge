describe Middlewares::HttpErrorHandler do
  let(:middleware) { described_class.new(app) }
  let(:app) { double('App') }
  let(:env) { double('Env') }

  describe "#new" do
    it 'accepts app' do
      expect(middleware).to be_a described_class
    end
  end

  describe "#call" do
    describe "if no exception is raised" do
      it 'calls app.call' do
        expect(app).to receive(:call).with(env)
        middleware.call(env)
      end
    end

    describe "if HttpError is raised" do
      before do
        exception = Api::Errors::HttpError.new('body')
        allow(app).to receive(:call).and_raise(exception)
        allow(exception).to receive(:status).and_return(400)
        allow(exception).to receive(:headers).and_return({})
        allow(exception).to receive(:body).and_return('body')
      end

      it 'catches the exception and uses its response parameters' do
        expect(middleware.call(env)).to eq [400, {}, ['body']]
      end
    end
  end
end
