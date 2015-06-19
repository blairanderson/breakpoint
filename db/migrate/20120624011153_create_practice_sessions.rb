class CreatePracticeSessions < ActiveRecord::Migration
  def change
    create_table :practice_sessions do |t|
      t.references :user
      t.references :practice

      t.timestamps
    end
    add_index :practice_sessions, :user_id
    add_index :practice_sessions, :practice_id
  end
end
