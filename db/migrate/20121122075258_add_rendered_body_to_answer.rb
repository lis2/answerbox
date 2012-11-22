class AddRenderedBodyToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :rendered_body, :text
  end
end
