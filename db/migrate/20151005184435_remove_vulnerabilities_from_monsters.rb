class RemoveVulnerabilitiesFromMonsters < ActiveRecord::Migration
  def change
    remove_column :monsters, :damage_vulnerabilities, :string
  end
end
