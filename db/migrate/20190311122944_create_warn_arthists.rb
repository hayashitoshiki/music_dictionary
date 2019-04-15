class CreateWarnArthists < ActiveRecord::Migration[5.2]
  def change
    create_table :warn_arthists do |t|
      t.string :name
      t.integer :wrong_name
      t.integer :exist_name

      t.timestamps
    end
  end
end
