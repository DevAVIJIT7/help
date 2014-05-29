class AddCommentsCountToSupports < ActiveRecord::Migration
  def change
    add_column :supports, :comments_count, :integer, default: 0

    Support.reset_column_information
    Support.all.each do |support|
      support.update_attribute :comments_count, support.comments.count
    end
  end
end
