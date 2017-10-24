class CreateValues < ActiveRecord::Migration[4.2]
  def change
    create_table :values do |t|
      t.integer :value
    end
  end
end
