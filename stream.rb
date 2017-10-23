require 'nokogiri'
require 'open-uri'
require 'json'
require 'launchy'

# Give user name here
@user_name = 'clorox'
# @user_name = 'amiteshkumar'

def build_static_html
  document = getPage()
  getJsonData(document.css("script"))
end

def getJsonData(scripts)
  jsonData = []
  scripts.each do |script|
    if script.to_s.include? 'window._sharedData' then
      content = script.content
      content = content.gsub('window._sharedData = ', '').gsub(/;$/, '')
      jsonData = JSON.parse(content)
      jsonData = jsonData['entry_data']['ProfilePage'][0]['user']['media']['nodes']
      puts "script =>#{jsonData}"
    end
  end
  jsonData
end

def getPage
  html = open("https://www.instagram.com/#{@user_name}")
  content = Nokogiri::HTML(html)
  # puts "content #{content}"
  content
end

def generateHTML(feeds)
	html = '<html><head><style>img{ max-height:200px; max-width:200px; border:4px solid #cacaca;; margin:5px;} p{color: #444;}</style></head><body>'
	feeds.each do |feed|
		html = html + "<div><img src=\"#{feed['thumbnail_src']}\"><br><p>#{feed['caption']}</p><div>Likes : #{feed['likes']['count']}</div></div>"
	end

	html += '</body></html>'
	file = File.join(Dir.pwd,'feeds.html')
	File.write(file, html)

	puts file
	openPage(file)
end

def openPage(file)
	Launchy.open(file)
end

feeds = build_static_html()

generateHTML(feeds)
