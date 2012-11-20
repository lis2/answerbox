class RemoveUpdatedAtFromTagsQuestions < ActiveRecord::Migration
  def up
    remove_column :questions_tags, :updated_at
  end

  def down
    add_column :questions_tags, :updated_at
  end
end
