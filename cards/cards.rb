require 'nokogiri'

document = Nokogiri::XML(File.read('monsters.xml'))
template = Nokogiri::XSLT(File.read('template.xsl'))

transformed_document = template.transform(document)

File.open('output.html', 'w').write(transformed_document)

