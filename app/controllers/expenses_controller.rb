class ExpensesController < ApplicationController
  # Вивести всі витрати
  def index
    @expenses = Expense.all
    @expense = Expense.new  # Для форми додавання нової витрати
  end

  # Додати нову витрату
  def create
    @expense = Expense.new(expense_params)
    if @expense.save
      redirect_to root_path, notice: 'Витрату успішно додано.'
    else
      @expenses = Expense.all
      render :index
    end
  end

  # Оновити витрату
  def update
    @expense = Expense.find(params[:id])
    if @expense.update(expense_params)
      redirect_to root_path, notice: 'Витрату успішно оновлено.'
    else
      render :index
    end
  end

  # Видалити витрату
  def destroy
    @expense = Expense.find(params[:id])
    @expense.destroy
    redirect_to root_path, notice: 'Витрату успішно видалено.'
  end

  # Пошук витрат
  def search
    @expenses = Expense.where("name LIKE ?", "%#{params[:term]}%")
    render :index
  end

  # Зберегти витрати в JSON
  def save_json
    expenses = Expense.all
    File.open("expenses.json", "w") { |f| f.write(expenses.to_json) }
    redirect_to root_path, notice: 'Витрати збережено у JSON.'
  end

  # Завантажити витрати з JSON
  def load_json
    expenses_data = JSON.parse(File.read("expenses.json"))
    expenses_data.each do |expense|
      Expense.create(expense)
    end
    redirect_to root_path, notice: 'Витрати завантажено з JSON.'
  end

  # Зберегти витрати в YAML
  def save_yaml
    expenses = Expense.all
    File.open("expenses.yaml", "w") { |f| f.write(expenses.to_yaml) }
    redirect_to root_path, notice: 'Витрати збережено у YAML.'
  end

  # Завантажити витрати з YAML
  def load_yaml
    expenses_data = YAML.load_file("expenses.yaml")
    expenses_data.each do |expense|
      Expense.create(expense)
    end
    redirect_to root_path, notice: 'Витрати завантажено з YAML.'
  end

  private

  # Параметри витрати для безпеки
  def expense_params
    params.require(:expense).permit(:name, :amount, :date, :description)
  end
end
