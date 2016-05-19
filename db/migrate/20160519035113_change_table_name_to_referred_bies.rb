class ChangeTableNameToReferredBies < ActiveRecord::Migration
  def change
    rename_table :referred_bys, :referred_bies
  end
end
