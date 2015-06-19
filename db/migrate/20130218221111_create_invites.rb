class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.references :user
      t.references :team
      t.integer :invited_by_id
      t.datetime :accepted_at

      t.timestamps
    end
    add_index :invites, :user_id
    add_index :invites, :team_id
  end
end
