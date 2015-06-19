class CreateMatchAvailabilities < ActiveRecord::Migration
  def change
    create_table :match_availabilities do |t|
      t.references :user
      t.references :match

      t.timestamps
    end
    add_index :match_availabilities, :user_id
    add_index :match_availabilities, :match_id
  end
end
