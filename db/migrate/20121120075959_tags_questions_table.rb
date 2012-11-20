class TagsQuestionsTable < ActiveRecord::Migration
  def up
    create_table :tags_questions do |t|
      t.integer :tag_id
      t.integer :question_id
      t.timestamps
    end
  end

  def down
    remove_table :tags_questions
  end
end
