require 'pry'
require 'nokogiri'
require 'open-uri'
require 'watir'

# page = Nokogiri::HTML(URI.open("https://lannuaire.service-public.fr/ile-de-france/essonne/8971767f-e50c-4d58-9e69-94e7a489f49a"))



# Méthode qui récupère puis retourne le nom et le mail sous forme dans un hash
def get_townhall_email(townhall_url)

  hash = Hash.new

  townhall_email_xml = townhall_url.xpath('//a[@class ="send-mail"]')
  townhall_email = townhall_email_xml.text

  townhall_name_xml = townhall_url.xpath('//h1[@id ="titlePage"]')
  townhall_name = townhall_name_xml.text

  hash[townhall_name] = townhall_email

  puts hash
  return hash
end


# Méthode qui retourne les urls dans un tableau
def get_townhall_urls

  page = Nokogiri::HTML(URI.open("https://lannuaire.service-public.fr/navigation/ile-de-france/mairie"))

  townhall_urls = []

  begin
  townhall_urls_xml = page.xpath('//ul[@class="fr-raw-list"]//a[@class="fr-link"]')
  rescue => e
    puts "Erreur xpath : #{e.message}"
  end

  townhall_urls_xml.each do |url|
    townhall_urls << url['href']

  end
    return townhall_urls
end

# Méthode qui retourne le nom et le mail d'une ville dans un tableau contenant des hash
def get_mail_array
  result_array = []
  townhall_urls = get_townhall_urls

  townhall_urls.each do |url|
    page_url = Nokogiri::HTML(URI.open(url))
    result_array << get_townhall_email(page_url)
  end

    puts result_array
    return result_array
  end


# test = Nokogiri::HTML(URI.open("https://lannuaire.service-public.fr/ile-de-france/essonne/8971767f-e50c-4d58-9e69-94e7a489f49a"))
# get_townhall_urls
# get_townhall_email(test)
# get_townhall_name(test)
get_mail_array

