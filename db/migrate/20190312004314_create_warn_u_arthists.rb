class CreateWarnUArthists < ActiveRecord::Migration[5.2]
  def change
    create_table :warn_u_arthists do |t|
      t.string :user
      t.string :arthist

      t.timestamps
    end
  end
end
