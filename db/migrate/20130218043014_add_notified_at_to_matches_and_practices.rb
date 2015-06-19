class AddNotifiedAtToMatchesAndPractices < ActiveRecord::Migration
  def change
    add_column :practices, :notified_state, :string
    add_column :matches, :notified_state, :string
  end
end
