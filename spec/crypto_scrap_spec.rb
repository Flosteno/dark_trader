require_relative '../lib/crypto_scrap'
require 'nokogiri'

describe 'Crypto scraper' do
  let(:html) do
    <<-HTML
      <html>
        <body>
          <table class="cmc-table__table-wrapper-outer">
            <tr>
              <td></td>
              <td></td>
              <td><div>Bitcoin</div></td>
              <td></td>
              <td><span>$23,000.45</span></td>
            </tr>
            <tr>
              <td></td>
              <td></td>
              <td><div>Ethereum</div></td>
              <td></td>
              <td><span>$1,850.33</span></td>
            </tr>
            <tr>
              <td></td>
              <td></td>
              <td><div></div></td>
              <td></td>
              <td><span></span></td>
            </tr>
          </table>
        </body>
      </html>
    HTML
  end

  let(:page) { Nokogiri::HTML(html) }

  describe '#get_crypto_names' do
    it 'returns an array of names with nil for empty entries' do
      result = get_crypto_names(page)
      expect(result).to eq(['Bitcoin', 'Ethereum', nil])
    end
  end

  describe '#get_crypto_prices' do
    it 'returns an array of float prices with nil for empty entries' do
      result = get_crypto_prices(page)
      expect(result).to eq([23000.45, 1850.33, nil])
    end
  end

  describe '#get_cryptos' do
    it 'returns an array of hashes pairing names and prices' do
      result = get_cryptos(page)
      expect(result).to eq([
        { 'Bitcoin' => 23000.45 },
        { 'Ethereum' => 1850.33 },
        { nil => nil }
      ])
    end
  end
end
