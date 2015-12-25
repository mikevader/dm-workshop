require 'nokogiri/diff'

class CardExportTest < ActiveSupport::TestCase

  setup do
    @user = users(:michael)
  end

  test 'export monsters' do
    input_path = File.join(fixture_path, 'monsters.xml')
    file = Rack::Test::UploadedFile.new(input_path, 'text/xml')
    importer = CardImport.new monsters_file: file
    importer.save(@user)

    #export_path = File.join(fixture_path, 'monsters_new.xml')

    exporter = CardExport.new

    xml = exporter.load_monsters(Monster.where("name = 'Goblin' or name = 'Obgam Sohn des Brogar'"))
    org_file = Nokogiri::XML(File.open(input_path))
    new_file = Nokogiri::XML(xml)

    failure_text = ''
    org_file.diff(new_file, added: true, removed: true) do |change,node|
      case node.parent.path
        when '/cards'
        when '/cards/monsters/monster[1]/stats/cr'
        when '/cards/monsters/monster[2]/stats/skills/skill[1]'
        when '/cards/monsters/monster[2]/stats/skills/skill[2]'
        when '/cards/monsters/monster[2]/traits/trait[1]'
        else
          failure_text += "#{change} #{node.to_xml}".ljust(30) + node.parent.path + "\n"
      end

    end
    assert failure_text.empty?, "Found diffs:\n#{failure_text}"
  end
end