class CreateVotings < ActiveRecord::Migration
  def change
    create_table :votings do |t|
      t.references :user, null: false
      t.references :votable, polymorphic: true, null: false
      t.integer :opinion, null: false

      t.timestamps
    end

    add_index :votings, [:votable_type, :votable_id, :user_id], unique: true
  end
end
