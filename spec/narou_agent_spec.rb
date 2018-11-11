RSpec.describe NarouAgent do
  let(:agent) { described_class.new(driver: driver) }

  describe '#login!' do
    subject { agent.login!(id: id, password: password) }

    let(:id) { ENV.fetch('NAROU_ID') }
    let(:password) { ENV.fetch('NAROU_PASSWORD') }

    it { is_expected.to be true }
  end
end
