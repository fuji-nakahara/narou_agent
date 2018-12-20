RSpec.describe NarouAgent do
  let(:agent) { described_class.new(driver: driver) }

  let(:body) do
    <<~EOS
      機械の小説とは、機械について書かれた小説のことである。
      機械による小説とは、機械によって書かれた小説のことである。
      機械のための小説とは、機械の存続のために書かれた小説のことである。
      
      そして、この小説は|機械《ソフトウェア》の|機械《ソフトウェア》による|機械《ソフトウェア》のための小説である。
      この小説は、ある機械に関するものであり、ある機械によって書かれ、ある機械が正常に動作することを示すものである。
    EOS
  end

  describe '#login!' do
    subject { agent.login!(id: id, password: password) }

    let(:id) { ENV.fetch('NAROU_ID') }
    let(:password) { ENV.fetch('NAROU_PASSWORD') }

    it { is_expected.to be true }
  end

  describe '#create_part and #delete_part' do
    subject do
      part_url = agent.create_part(ncode: ncode, subtitle: subtitle, body: body)
      agent.delete_part(ncode: ncode, part_id: NarouAgent::UrlHelper.extract_part_id(part_url))
    end

    let(:ncode) { ENV.fetch('NCODE') }
    let(:subtitle) { '創造と破壊' }

    before do
      agent.login!(id: ENV.fetch('NAROU_ID'), password: ENV.fetch('NAROU_PASSWORD'))
    end

    it 'creates and deletes part without errors' do
      expect { subject }.not_to raise_error
    end
  end

  describe '#update_part' do
    subject { agent.update_part(ncode: ncode, part_id: part_id, subtitle: subtitle, body: body) }

    let(:ncode) { ENV.fetch('NCODE') }
    let(:part_id) { ENV.fetch('PART_ID') }
    let(:subtitle) { '改変' }

    before do
      agent.login!(id: ENV.fetch('NAROU_ID'), password: ENV.fetch('NAROU_PASSWORD'))
    end

    it { expect { subject }.not_to raise_error }
  end

  describe '#create_part and #update_part with future date' do
    subject do
      part_url = agent.create_part(ncode: ncode, subtitle: subtitle, body: body, date: date)
      @part_id = NarouAgent::UrlHelper.extract_part_id(part_url)
      agent.update_part(ncode: ncode, part_id: @part_id, subtitle: subtitle, body: body, date: date)
    end

    let(:ncode) { ENV.fetch('NCODE') }
    let(:subtitle) { '未来' }
    let(:date) { Time.now + 60 * 60 * 24 }

    before do
      agent.login!(id: ENV.fetch('NAROU_ID'), password: ENV.fetch('NAROU_PASSWORD'))
    end

    after do
      agent.delete_part(ncode: ncode, part_id: @part_id)
    end

    it 'creates and updates reserved part without errors' do
      expect { subject }.not_to raise_error
    end
  end
end
