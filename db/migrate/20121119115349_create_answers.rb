class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :user_id
      t.integer :question_id
      t.text :body
      t.boolean :answered, default: false

      t.timestamps
    end
  end
end
