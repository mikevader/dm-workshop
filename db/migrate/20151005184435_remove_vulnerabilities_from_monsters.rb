class RemoveVulnerabilitiesFromMonsters < ActiveRecord::Migration[5.0]
  def change
    remove_column :monsters, :damage_vulnerabilities, :string
  end
end
