class AddRenderedBodyToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :rendered_body, :text
  end
end
