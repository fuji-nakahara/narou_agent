RSpec.describe NarouAgent do
  let(:agent) { described_class.new(driver: driver) }

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
    let(:subtitle) { '投稿・削除テスト' }
    let(:body) do
      <<~EOS
        この小説は NarouAgent のテストで用いるためのものです。

        NarouAgent は、小説の投稿・編集・削除といった操作を代行するソフトウェアです。
        Selenium WebDriver を用いた Ruby gem として実装されています。

        https://github.com/fuji-nakahara/narou_agent
        
        この小説が削除されていなければ、NarouAgent の削除機能に問題が起きています。
      EOS
    end

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
    let(:subtitle) { '編集テスト' }
    let(:body) do
      <<~EOS
        この小説は NarouAgent のテストで用いるためのものです。

        NarouAgent は、小説の投稿・編集・削除といった操作を代行するソフトウェアです。
        Selenium WebDriver を用いた Ruby gem として実装されています。

        https://github.com/fuji-nakahara/narou_agent
        
        この小説は NarouAgent によって #{Time.now.strftime('%Y年%m月%d日%H時%M分')} に編集されました。
      EOS
    end

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
    let(:subtitle) { '予約テスト' }
    let(:body) do
      <<~EOS
        この小説は NarouAgent のテストで用いるためのものです。

        NarouAgent は、小説の投稿・編集・削除といった操作を代行するソフトウェアです。
        Selenium WebDriver を用いた Ruby gem として実装されています。

        https://github.com/fuji-nakahara/narou_agent
        
        この小説は NarouAgent によって #{Time.now.strftime('%Y年%m月%d日%H時%M分')} に編集されました。
      EOS
    end
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
