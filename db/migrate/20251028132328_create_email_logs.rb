class CreateEmailLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :email_logs do |t|
      t.string :filename
      t.string :status
      t.text :extracted_data
      t.text :error_message
      t.datetime :processed_at

      t.timestamps
    end
  end
end
