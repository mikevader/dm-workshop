# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks


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


desc 'Provision dev with prod data and start migration.'
task :prepare_dev_from_stage do
  heroku 'pg:backups:capture --app dmw-staging'
  backup_url = heroku 'pg:backups:url --app dmw-staging | cat'
  puts "Backup file can be found under: #{backup_url}"

  heroku "pg:backups:restore '#{backup_url}' DATABASE --app dmw-development  --confirm dmw-development"
  heroku 'run rake db:migrate --app dmw-development'
end


# (prepare heroku to have pipeline tools) heroku plugins:install heroku-pipelines
desc 'Release the currently staged version to prod incl. migration'
task :release_from_stage do
  heroku 'pg:backups:capture --app dmw'
  heroku 'pipelines:promote --app dmw-staging'
  heroku 'run rake db:migrate --app dmw'
end

# Executes a command in the Heroku Toolbelt
def heroku(command)
  Bundler.with_clean_env do
    output = %x[heroku #{command}]
    $?.success? or abort "heroku command failed! #{command}"
    return output
  end
end
