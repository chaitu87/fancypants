require 'rubygems'
require 'json'
require 'nokogiri'
require 'awesome_print'
require 'restclient'
require 'faraday'
require 'cgi'

page = Nokogiri::HTML(RestClient.get("https://www.socks-proxy.net/"))
listofproxies = page.css('#proxylisttable tbody tr')
masterlist = []
listofproxies.each do |proxy|
	temp = {}
	temp[:ip] = proxy.css('td:nth-child(1)').text
	temp[:port] = proxy.css('td:nth-child(2)').text
	ap temp
end