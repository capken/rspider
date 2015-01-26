class ChangeStatusCodeType < ActiveRecord::Migration
  def change
    change_column :pages, :status_code, :integer, :default => 0, :null => false
  end
end
