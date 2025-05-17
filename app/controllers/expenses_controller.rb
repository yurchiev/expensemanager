require 'json'
require 'yaml'

class ExpensesController < ApplicationController
  FILE_JSON = 'storage/expenses.json'
  FILE_YAML = 'storage/expenses.yaml'

  def index
    @expenses = Expense.all.order(created_at: :desc)
  end

  def create
    @expense = Expense.new(expense_params)
    redirect_to root_path
  end

  def update
    @expense = Expense.find(params[:id])
    redirect_to root_path
  end

  def destroy
    @expense = Expense.find(params[:id])
    redirect_to root_path
  end

  def save_json
    expenses = Expense.all.map(&:attributes)
    File.write(FILE_JSON, JSON.pretty_generate(expenses))
    redirect_to root_path
  end

  def save_yaml
    expenses = Expense.all.map(&:attributes)
    File.write(FILE_YAML, expenses.to_yaml)
    redirect_to root_path
  end

  def load_json
    if File.exist?(FILE_JSON)
      data = JSON.parse(File.read(FILE_JSON))
      Expense.destroy_all
      data.each do |attrs|
        Expense.create(attrs.except("id", "created_at", "updated_at"))
      end
    end
    redirect_to root_path
  end

  def load_yaml
    if File.exist?(FILE_YAML)
      data = YAML.load_file(FILE_YAML)
      Expense.destroy_all
      data.each do |attrs|
        Expense.create(attrs.except("id", "created_at", "updated_at"))
      end
    end
    redirect_to root_path
  end

  private

  def expense_params
    params.permit(:name, :amount, :date, :description)
  end
end
