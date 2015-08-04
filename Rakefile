task :default => [:make]

desc "make xlst transform"
task :make do
  require 'nokogiri'
  require 'wicked_pdf'

  monsterDocument = Nokogiri::XML(File.read('monsters.xml'))
  monsterTemplate = Nokogiri::XSLT(File.read('monster_template.xsl'))
  File.open('monsters.html', 'w').write(monsterTemplate.transform(monsterDocument))

  spellDocument = Nokogiri::XML(File.read('spells.xml'))
  spellTemplate = Nokogiri::XSLT(File.read('spell_template.xsl'))
  File.open('spells.html', 'w').write(spellTemplate.transform(spellDocument))

  itemDocument = Nokogiri::XML(File.read('items.xml'))
  itemTemplate = Nokogiri::XSLT(File.read('item_template.xsl'))
  File.open('items.html', 'w').write(itemTemplate.transform(itemDocument))

end



