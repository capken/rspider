class AddStatusCodeOfPage < ActiveRecord::Migration
  def change
    change_table :pages do |t|
      t.string :status_code
    end
  end
end
