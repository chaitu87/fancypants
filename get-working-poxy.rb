require 'rubygems'
require 'json'
require 'nokogiri'
require 'awesome_print'
require 'restclient'
require 'faraday'
require 'cgi'
require 'net/ping'

@shortlistedproxy = []

##
# creates new connection to google.com using +Faraday+ lib. Uses CGI::Cookie class
# to parse the cookie returned in the response. It then checks for the presense of
# "NID" cookie set by Google. If the cookie exists, proxy server is working just fine.
#
def test(proxy)
	begin
		f = Faraday.new(:proxy => { :uri => "http://" + proxy})
		response = f.get "http://www.google.co.in"
		@cookie = CGI::Cookie.parse(response.headers["set-cookie"])
		if(!@cookie["NID"].empty?)
			# ap proxy
			@shortlistedproxy.push(proxy)
		end
	rescue
		# puts ":(\nConnection to #{proxy} timed out."
	end
end

page = Nokogiri::HTML(RestClient.get("https://www.socks-proxy.net/"))
listofproxies = page.css('#proxylisttable tbody tr')
masterlist = []
listofproxies.each do |proxy|
	temp = {}
	temp[:ip] = proxy.css('td:nth-child(1)').text
	temp[:port] = proxy.css('td:nth-child(2)').text
	temp[:country] = proxy.css('td:nth-child(3)').text
	# ap temp
	pr = "#{temp[:ip]}:#{temp[:port]}"
	if temp[:country] == "US"
		test(pr)
	end
end

ap @shortlistedproxy
