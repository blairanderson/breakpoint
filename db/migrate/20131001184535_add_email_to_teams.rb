class AddEmailToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :email, :string, null: false, default: ""
    Team.all.each { |t| t.update_attributes(email: t.name.parameterize) }
  end
end
