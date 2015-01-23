class SetupPageModel < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :md5
      t.index :md5
      t.string :url
      t.string :domain
      t.datetime :last_cached_at
      t.timestamps null: false
    end
  end
end
