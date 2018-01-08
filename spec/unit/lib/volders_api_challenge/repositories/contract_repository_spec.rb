describe ContractRepository do
  let(:repo) { described_class.new }

  it 'extends from Hanami::Repository' do
    expect(repo).to be_a Hanami::Repository
  end

  describe "#count" do
    it 'calls contracts.count' do
      allow_any_instance_of(described_class).to receive(:contracts).and_return(double("Contracts", count: 2))
      expect(repo.count).to eq 2
    end
  end

  describe '#find_by_id_and_user_id' do
    it 'calls contracts.where with right parameters' do
      row = double("Row")
      where_clause = double("WhereClause")
      one_clause = double("OneClause", one: row)
      allow(where_clause).to receive(:where).with({id: 1, user_id: 2}).and_return(one_clause)
      allow_any_instance_of(described_class).to receive(:contracts).and_return(where_clause)

      expect(repo.find_by_id_and_user_id(1, 2)).to eq row
    end
  end
end
