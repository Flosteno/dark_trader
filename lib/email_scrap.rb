require 'pry'
require 'nokogiri'
require 'open-uri'
require 'watir'

# page = Nokogiri::HTML(URI.open("https://lannuaire.service-public.fr/ile-de-france/essonne/8971767f-e50c-4d58-9e69-94e7a489f49a"))



# Méthode qui récupère puis retourne le nom et le mail sous forme dans un hash
def get_townhall_email(townhall_url)

  hash = Hash.new

  begin
  townhall_email_html = townhall_url.xpath('//a[@class ="send-mail"]')
  rescue => e
    puts "Erreur xpath : #{e.message}"
    townhall_email_html = nil
  end

  townhall_email = townhall_email_html.text
  if townhall_email.empty?
    townhall_email = nil
  end

  begin
  townhall_name_html = townhall_url.xpath('//h1[@id ="titlePage"]')
  rescue => e
    puts "Erreur xpath : #{e.message}"
    townhall_name_html = nil
  end

  townhall_name = townhall_name_html.text
  if townhall_name.empty?
    townhall_name = nil
  end

  hash[townhall_name] = townhall_email

  return hash
end


# Méthode qui retourne les urls dans un tableau
def get_townhall_urls

  page = Nokogiri::HTML(URI.open("https://lannuaire.service-public.fr/navigation/ile-de-france/mairie"))

  townhall_urls = []

  begin
  townhall_urls_html = page.xpath('//ul[@class="fr-raw-list"]//a[@class="fr-link"]')
  rescue => e
    puts "Erreur xpath : #{e.message}"
  end

  townhall_urls_html.each do |url|
  townhall_urls << url['href']

  end
    return townhall_urls
end

# Méthode qui retourne le nom et le mail d'une ville dans un tableau contenant des hash
def get_email_array
  result_array = []
  incomplete_data = 0
  townhall_urls = get_townhall_urls

  townhall_urls.each do |url|
    page_url = Nokogiri::HTML(URI.open(url))
    result_array << get_townhall_email(page_url)
  end

  result_array.each do |email_hash|
      key = email_hash.keys.first
      value = email_hash.values.first
      
      if key.nil? || value.nil?
        incomplete_data += 1
      end
    end
    puts "Il y a #{incomplete_data} données incomplètes"
    puts result_array
    return result_array
  end


# test = Nokogiri::HTML(URI.open("https://lannuaire.service-public.fr/ile-de-france/essonne/8971767f-e50c-4d58-9e69-94e7a489f49a"))
# get_townhall_urls
# get_townhall_email(test)
# get_townhall_name(test)
get_email_array

