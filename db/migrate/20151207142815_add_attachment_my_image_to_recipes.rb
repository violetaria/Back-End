class AddAttachmentMyImageToRecipes < ActiveRecord::Migration
  def self.up
    change_table :recipes do |t|
      t.attachment :my_image
    end
  end

  def self.down
    remove_attachment :recipes, :my_image
  end
end
