class ChangeTagsQuestionsTableName < ActiveRecord::Migration
  def up
    rename_table :tags_questions, :questions_tags
  end

  def down
    rename_table :questions_tags, :tags_questions
  end
end
