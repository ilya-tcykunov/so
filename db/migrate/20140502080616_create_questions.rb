class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :title, null: false
      t.text :body, null: false
      t.references :user, index: true

      t.timestamps
    end
  end
end