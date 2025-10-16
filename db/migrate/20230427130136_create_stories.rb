class CreateStories < ActiveRecord::Migration[7.0]
  def change
    create_table :stories do |t|
      t.string :title
      t.string :url
      t.integer :external_id

      t.timestamps
    end

    add_index :stories, :id
    add_index :stories, :created_at
    add_index :stories, :external_id, unique: true
  end
end
