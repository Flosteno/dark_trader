require_relative '../lib/email_scrap'
require 'nokogiri'


describe 'get_townhall_email' do
  let(:html) do
    <<-HTML
      <html>
        <body>
          <h1 id="titlePage">Mairie de Testville</h1>
          <a class="send-mail">contact@testville.fr</a>
        </body>
      </html>
    HTML
  end

  let(:fake_page) { Nokogiri::HTML(html) }

  it 'retourne un hash avec le nom de la ville comme clé et l\'email comme valeur' do
    expected_result = { "Mairie de Testville" => "contact@testville.fr" }
    expect(get_townhall_email(fake_page)).to eq(expected_result)
  end

  it 'affiche le hash dans la console' do
    expect { get_townhall_email(fake_page) }.to output(/Mairie de Testville.*contact@testville\.fr/).to_stdout
  end
end
