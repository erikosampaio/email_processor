class CreateEmailFiles < ActiveRecord::Migration[8.0]
  def change
    create_table :email_files do |t|
      t.string :filename
      t.text :content
      t.datetime :uploaded_at

      t.timestamps
    end
  end
end
