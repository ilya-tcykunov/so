class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :file
      t.references :attachmentable, polymorphic: true, index: true, null: false

      t.timestamps
    end
  end
end
