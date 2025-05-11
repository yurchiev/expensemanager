class CreateExpensePaymentMethods < ActiveRecord::Migration[8.0]
  def change
    create_table :expense_payment_methods do |t|
      t.references :expense, null: false, foreign_key: true
      t.references :payment_method, null: false, foreign_key: true

      t.timestamps
    end
  end
end
