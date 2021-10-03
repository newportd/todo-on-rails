class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.text :body, null: false
      t.datetime :completed_at

      t.timestamps
    end
  end
end
