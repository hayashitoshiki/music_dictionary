class CreateArthists < ActiveRecord::Migration[5.2]
  def change
    create_table :arthists do |t|
      t.string :name
      t.string :gender
      t.integer :voice
      t.integer :length
      t.integer :lyrics
      t.string :genre1
      t.string :genre2
      t.string :lyrics_genre
      t.integer :generation1
      t.integer :generation2
      t.integer :generation3
      t.integer :generation4
      t.integer :generation5
      t.integer :generation6
      t.integer :pick_up
      t.integer :count

      t.timestamps
    end
  end
end
