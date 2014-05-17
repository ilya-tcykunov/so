class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :body, null: false
      t.references :user, index: true, null: false
      t.references :commentable, polymorphic: true, index: true, null: false

      t.timestamps
    end
  end
end
