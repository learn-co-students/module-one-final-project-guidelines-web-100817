class CreateValues < ActiveRecord::Migration
  def change
    create_table :values do |t|
      t.integer = :value
  end
end
