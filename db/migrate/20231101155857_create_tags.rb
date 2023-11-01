class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.integer :chat_id
      t.string :title
      t.string :value

      t.timestamps
    end
  end
end
