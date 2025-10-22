class CreateMagazines < ActiveRecord::Migration[8.0]
  def change
    create_table :magazines do |t|
      t.string :title
      t.date :published_at
      t.string :isbn

      t.timestamps
    end
  end
end
