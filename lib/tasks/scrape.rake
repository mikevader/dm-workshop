
class String
  def is_number?
    true if Float(self) rescue false
  end
end


task :scrape do
  mechanize = Mechanize.new
  page = mechanize.get('http://www.dnd-spells.com/spells')

  builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
    xml.cards {
      xml.spells {


        page.links_with(href: %r{www.dnd-spells.com/spell/}).each do |link|
          if link.text.include?('Glyph of Warding') or link.text.include?('Trap the Soul')
            next
          end
          puts "Scraping Spell '#{link.text}'"

          spell = link.click
          details = spell.at('.container div.col-lg-10')
          name = details.at('h1').text.strip
          puts "   name: #{name}"
          school = details.css('p')[0].text.strip
          puts "   school: #{school}"
          level = details.css('p strong')[0].text.strip
          puts "   level: #{level}"
          casting_time = details.css('p strong')[1].text.strip
          puts "   casting_time: #{casting_time}"
          range = details.css('p strong')[2].text.strip
          puts "   range: #{range}"
          components = details.css('p strong')[3].text.strip
          puts "   components: #{components}"
          duration = details.css('p strong')[4].text.strip
          puts "   duration: #{duration}"

          description = details.css('p')[2].text.strip
          puts "   description: #{description}"

          next_id = 3

          at_higher_level = unless details.at("h4:contains('At higher level')").nil?
                              next_id += 1
                              details.css('p')[3].text.strip
                            else
                              ''
                            end
          puts "   at_higher_level: #{at_higher_level}"
          reference = details.css('p')[next_id].text.strip
          puts "   reference: #{reference}"
          next_id += 1

          classes = details.css('p')[next_id].text.strip
          classes = classes.squish.scan(/^A (.*) spell/i)[0][0].split(%r{,\s*})
          puts "   classes: #{classes}"

          xml.spell {
            xml.cite reference
            xml.name name

            xml.type_ "#{level}-level #{school}" if level.is_number?
            xml.type_ "#{school.capitalize} cantrip" unless level.is_number?

            xml.classes {
              classes.each do |class_|
                xml.class_ class_
              end
            }
            xml.castingTime casting_time
            xml.range range
            xml.components components
            xml.duration duration
            xml.atHigherLevel at_higher_level
            xml.description {
              xml << "\n#{'  '*4}#{description}\n#{'  '*3}"
            }
          }
        end
      }
    }
  end

  xml_file = builder.to_xml(indent: 2)

  file = File.open('spells.xml', 'w+')
  file.write(xml_file)
  file.close
end
