class CreateJoinTableAuthorMagazine < ActiveRecord::Migration[8.0]
  def change
    create_join_table :authors, :magazines do |t|
      # t.index [:author_id, :magazine_id]
      # t.index [:magazine_id, :author_id]
    end
  end
end
