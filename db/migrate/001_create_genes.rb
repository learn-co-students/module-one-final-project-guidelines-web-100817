class CreateGenes < ActiveRecord::Migration[4.2]
  def change
    create_table :genes do |t|
      t.string :name
    end
  end
end
