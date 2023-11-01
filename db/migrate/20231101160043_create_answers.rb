class CreateAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :answers do |t|
      t.integer :feedback_id
      t.string :header
      t.string :title
      t.string :value

      t.timestamps
    end
  end
end
