require "spec_helper"

RSpec.describe Api::Views::ApplicationLayout, type: :view do
  let(:layout)   { Api::Views::ApplicationLayout.new(template, {}) }
  let(:rendered) { layout.render }
  let(:template) { Hanami::View::Template.new('apps/api/templates/application.html.erb') }

  it 'contains application name' do
    expect(rendered).to include('Api')
  end
end
