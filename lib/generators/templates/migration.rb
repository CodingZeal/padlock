class CreatePadlocks < ActiveRecord::Migration
  def up
    create_table :padlocks do |t|
      t.integer :lockable_id
      t.string  :lockable_type
      t.integer :user_id

      t.timestamps
    end
  end

  def down
    drop_table :padlocks
  end
end
