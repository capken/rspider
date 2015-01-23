class SetupJobAndTaskModel < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :tasks do |t|
      t.integer :page_id
      t.belongs_to :job, index:true
      t.string :status
      t.timestamps null: false
    end
  end
end
