require 'nokogiri'
require 'open-uri'
require 'pry'

page = Nokogiri::HTML(URI.open("https://coinmarketcap.com/all/views/all/"))
# div class = cmc-table__table-wrapper-outer
  # each tr
    #td 3 div && td 5 span

# Méthode qui récupère puis retourne les noms des cryptos dans un tableau
def get_crypto_names(page)

  crypto_names = []

  begin
    crypto_names_html = page.xpath('//tr//td[3]/div')
  rescue => e
    puts "Erreur XPath : #{e.message}"
    return []
  end

  if crypto_names_html.empty?
    puts "Aucun élément trouvé"
    return []
  else
    count_invalid = 0
    crypto_names_html.each do |text_html|
      
      crypto_name = text_html.text.strip

      if crypto_name.empty?
        count_invalid += 1
        crypto_names << nil
      else
        crypto_names << crypto_name
      end

    end

    puts "#{count_invalid} noms invalides"
    puts "Récupération des noms complétée"
  end
   return crypto_names
end


# Méthode qui récupère puis retourne les prix des cryptos dans un tableau
def get_crypto_prices(page)

  crypto_prices = []

  begin 
    crypto_prices_html = page.xpath('//tr//td[5]//span')
  rescue => e
    puts "Erreur Xpath : #{e.message}"
    return []
  end
  
  if crypto_prices_html.empty?
    puts "Aucun élément trouvé"
    return []
  else
    count_invalid = 0

    crypto_prices_html.each do |text_html|

      crypto_price = text_html.text.strip.gsub(/[$,]/, '')

      if crypto_price.empty?
        count_invalid += 1 
        crypto_prices << nil
      else
        crypto_prices << crypto_price.to_f
      end

    end
    puts "#{count_invalid} prix invalides"
    puts "Récupération des prix complétée"
  end
  return crypto_prices
end

# Méthode qui retourne les cryptos et leurs coûts sous forme de hash dans un tableau
def get_cryptos(page)

  crypto_names = get_crypto_names(page)
  crypto_prices = get_crypto_prices(page)

  hash = crypto_names.zip(crypto_prices).to_h
  array_of_hashes = hash.map {|key, value| {key => value}}

  if crypto_names.length != crypto_prices.length
  puts "Attention : #{crypto_names.length} noms vs #{crypto_prices.length} prix"
  end

  for i in 0..2 do
    if !crypto_names[i].nil? && !crypto_prices[i].nil?
      puts "Donnée #{i+1}/3 validée"
    else
      puts "Donnée #{i+1}/3 manquante"
    end
  end
  
  if array_of_hashes.empty?
    puts "Les données n'ont pas été récupéré convenablement"
  else
    incomplete_data = 0

    array_of_hashes.each do |crypto_hash|
      key = crypto_hash.keys.first
      value = crypto_hash.values.first

      if key.nil? || value.nil?
        incomplete_data += 1
      end
   
    end
    puts "Il y a #{incomplete_data} données incomplètes"
    puts array_of_hashes
    return array_of_hashes
  end
end

# get_crypto_names(page)
# get_crypto_prices(page)
get_cryptos(page)
