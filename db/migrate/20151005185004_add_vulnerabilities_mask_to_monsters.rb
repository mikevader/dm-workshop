class AddVulnerabilitiesMaskToMonsters < ActiveRecord::Migration[5.0]
  def change
    add_column :monsters, :damage_vulnerabilities_mask, :integer
  end
end
