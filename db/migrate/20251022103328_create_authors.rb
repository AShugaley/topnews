class CreateAuthors < ActiveRecord::Migration[8.0]
  def change
    create_table :authors do |t|
      t.string :email
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
