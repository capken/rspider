class SetupPageModel < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :md5
      t.index :md5
      t.string :url
      t.string :domain
      t.timestamps null: false
    end
  end
end
