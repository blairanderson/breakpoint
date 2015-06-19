class MakePracticeAndMatchFieldsMoreConsistent < ActiveRecord::Migration
  def up
    change_column :matches, :location, :text
    remove_column :matches, :opponent
    add_column :matches, :home_team, :boolean, :default => true
    add_column :matches, :comment, :text
    add_column :practices, :location, :text
  end

  def down
    remove_column :practices, :location
    remove_column :matches, :comment
    remove_column :matches, :home_team
    add_column :matches, :opponent, :string
    change_column :matches, :location, :string
  end
end

