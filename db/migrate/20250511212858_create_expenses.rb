class CreateExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :expenses do |t|
      t.string :name
      t.decimal :amount, precision: 10, scale: 2
      t.date :date
      t.text :description

      t.timestamps
    end
  end
end
