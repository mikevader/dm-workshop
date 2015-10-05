class AddVulnerabilitiesMaskToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :damage_vulnerabilities_mask, :integer
  end
end
