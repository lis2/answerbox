class RemoveCreatedAtFromTagsQuestions < ActiveRecord::Migration
  def up
    remove_column :questions_tags, :created_at
  end

  def down
    add_column :questions_tags, :created_at
  end
end
