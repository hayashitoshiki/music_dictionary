class CreateUArthists < ActiveRecord::Migration[5.2]
  def change
    create_table :u_arthists do |t|
      t.string :arthist
      t.integer :gender
      t.integer :voice
      t.integer :length
      t.integer :lyrics
      t.integer :genre1
      t.integer :genre2
      t.integer :lyrics_genre
      t.integer :generation
      t.integer :pick_up
      t.string :account

      t.timestamps
    end
  end
end
