class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :title
      t.text :body
      t.references :user, index: true

      t.timestamps
    end
  end
end
m 