class CreateQuestionTable < ActiveRecord::Migration

  def change
    create_table :questions do |t|
      t.string :question
      t.string :answer
      t.integer :category_id
      t.integer :value_id
      t.integer :date
    end
  end

end
