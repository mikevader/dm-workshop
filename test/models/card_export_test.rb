require 'nokogiri/diff'
require 'test_helper'

class CardExportTest < ActiveSupport::TestCase

  setup do
    @user = users(:michael)
  end

  test 'export monsters' do
    input_path = File.join(fixture_path, 'monsters.xml')
    file = Rack::Test::UploadedFile.new(input_path, 'text/xml')
    importer = CardImport.new(@user, monsters_file: file)
    importer.import_monsters
    importer.save

    #export_path = File.join(fixture_path, 'monsters_new.xml')

    exporter = CardExport.new

    xml = exporter.load_monsters(Monster.where("name = 'Goblin' or name = 'Obgam Sohn des Brogar'"))
    org_file = Nokogiri::XML(File.open(input_path))
    new_file = Nokogiri::XML(xml)

    failure_text = ''
    org_file.diff(new_file, added: true, removed: true) do |change, node|
      case node.parent.path
        when '/cards'
        when '/cards/monsters/monster[2]/stats/skills/skill[1]'
        when '/cards/monsters/monster[2]/stats/skills/skill[2]'
        when '/cards/monsters/monster[2]/traits/trait[1]'
        else
          failure_text += "#{change} #{node.to_xml}".ljust(30) + node.parent.path + "\n"
      end

    end
    assert failure_text.empty?, "Found diffs:\n#{failure_text}"
  end


  test 'export spells' do
    input_path = File.join(fixture_path, 'spells.xml')
    file = Rack::Test::UploadedFile.new(input_path, 'text/xml')
    importer = CardImport.new(@user, spells_file: file)
    importer.import_spells
    importer.save

    exporter = CardExport.new
    xml = exporter.load_spells(Spell.where("name = 'Antilife Shell' or name = 'Magic Missile' or name = 'Alarm'"))
    org_file = Nokogiri::XML(File.open(input_path))
    new_file = Nokogiri::XML(xml)

    failure_text = ''
    org_file.diff(new_file, added: true, removed: true) do |change, node|
      case node.parent.path
        when '/asdfasdf'
        else
          failure_text += "#{change} #{node.to_xml}".ljust(30) + node.parent.path + "\n"
      end

    end
    assert failure_text.empty?, "Found diffs:\n#{failure_text}"
  end

  test 'export items' do
    input_path = File.join(fixture_path, 'items.xml')
    file = Rack::Test::UploadedFile.new(input_path, 'text/xml')
    importer = CardImport.new(@user, items_file: file)
    importer.import_items
    importer.save

    exporter = CardExport.new
    xml = exporter.load_items(Item.where("name = 'Schutzring' or name = 'Speer des Blitzes'"))
    org_file = Nokogiri::XML(File.open(input_path))
    new_file = Nokogiri::XML(xml)

    failure_text = ''
    org_file.diff(new_file, added: true, removed: true) do |change, node|
      case node.parent.path
        when '/asdfasdf'
        else
          failure_text += "#{change} #{node.to_xml}".ljust(30) + node.parent.path + "\n"
      end

    end
    assert failure_text.empty?, "Found diffs:\n#{failure_text}"
  end

  test 'export cards' do
    input_path = File.join(fixture_path, 'cards.xml')
    file = Rack::Test::UploadedFile.new(input_path, 'text/xml')
    importer = CardImport.new(@user, cards_file: file)
    importer.import_cards
    importer.save

    exporter = CardExport.new
    xml = exporter.load_cards(Card.where("name = 'Frenzy' or name = 'Wand of Iseth'"))
    org_file = Nokogiri::XML(File.open(input_path))
    new_file = Nokogiri::XML(xml)

    failure_text = ''
    org_file.diff(new_file, added: true, removed: true) do |change, node|
      case node.parent.path
        when '/asdfasdf'
        else
          failure_text += "#{change} #{node.to_xml}".ljust(30) + node.parent.path + "\n"
      end

    end
    assert failure_text.empty?, "Found diffs:\n#{failure_text}"
  end
end
