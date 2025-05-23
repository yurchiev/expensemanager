require 'yaml'
require 'json'

class Expense
  attr_accessor :name, :amount, :date, :description

  def initialize(name, amount, date, description)
    @name = name
    @amount = amount
    @date = date
    @description = description
    validate!
  end

  def to_h
    { name => { amount: amount, date: date, description: description } }
  end

  def validate!
    raise ArgumentError, "Сума має бути числом більше нуля" unless amount.is_a?(Numeric) && amount > 0
    raise ArgumentError, "Дата має бути у форматі YYYY-MM-DD" unless date.match?(/\A\d{4}-\d{2}-\d{2}\z/)
  end
end

class ExpenseManager
  FILE_JSON = 'storage/expenses.json'
  FILE_YAML = 'storage/expenses.yaml'

  def initialize
    @expenses = {} # Хеш: { "Назва витрати" => { amount, date, description } }
  end

  def run
    loop do
      puts "\n--- Менеджер витрат ---"
      puts "1. Переглянути витрати"
      puts "2. Додати витрату"
      puts "3. Редагувати витрату"
      puts "4. Видалити витрату"
      puts "5. Зберегти у JSON"
      puts "6. Зберегти у YAML"
      puts "7. Завантажити з JSON"
      puts "8. Завантажити з YAML"
      puts "9. Вийти"
      print "Ваш вибір: "
      case gets.to_i
      when 1 then list_expenses
      when 2 then add_expense
      when 3 then edit_expense
      when 4 then delete_expense
      when 5 then save_to_json
      when 6 then save_to_yaml
      when 7 then load_from_json
      when 8 then load_from_yaml
      when 9 then break
      else puts "Невірний вибір"
      end
    end
  end

  def list_expenses
    if @expenses.empty?
      puts "Витрати відсутні."
    else
      @expenses.each_with_index do |(name, details), index|
        puts "#{index + 1}. Назва: #{name}, Сума: #{details[:amount]}, Дата: #{details[:date]}, Опис: #{details[:description]}"
      end
    end
  end

  def add_expense
    print "Введіть назву витрати: "
    name = gets.strip
    print "Введіть суму витрати: "
    amount = gets.strip.to_f
    print "Введіть дату витрати (формат: YYYY-MM-DD): "
    date = gets.strip
    print "Введіть опис витрати: "
    description = gets.strip

    begin
      expense = Expense.new(name, amount, date, description)
      @expenses.merge!(expense.to_h)
      puts "Витрату додано."
      list_expenses
    rescue ArgumentError => e
      puts "Помилка: #{e.message}"
    end
  end

  def edit_expense
    list_expenses
    print "Введіть назву витрати для редагування: "
    name = gets.strip
    if @expenses[name]
      print "Нова сума витрати: "
      amount = gets.strip.to_f
      print "Нова дата витрати (формат: YYYY-MM-DD): "
      date = gets.strip
      print "Новий опис витрати: "
      description = gets.strip

      begin
        expense = Expense.new(name, amount, date, description)
        @expenses[name] = { amount: amount, date: date, description: description }
        puts "Витрату оновлено."
        list_expenses
      rescue ArgumentError => e
        puts "Помилка: #{e.message}"
      end
    else
      puts "Витрату не знайдено."
    end
  end

  def delete_expense
    list_expenses
    print "Введіть назву витрати для видалення: "
    name = gets.strip
    if @expenses.delete(name)
      puts "Витрату видалено."
      list_expenses
    else
      puts "Витрату не знайдено."
    end
  end

  def save_to_json
    File.write(FILE_JSON, JSON.pretty_generate(@expenses))
    puts "Збережено у JSON."
    list_expenses
  end

  def save_to_yaml
    File.write(FILE_YAML, @expenses.to_yaml)
    puts "Збережено у YAML."
    list_expenses
  end

  def load_from_json
    if File.exist?(FILE_JSON)
      @expenses = JSON.parse(File.read(FILE_JSON), symbolize_names: true)
      puts "Завантажено з JSON."
      list_expenses
    else
      puts "Файл JSON не знайдено."
    end
  end

  def load_from_yaml
    if File.exist?(FILE_YAML)
      @expenses = YAML.load_file(FILE_YAML)
      puts "Завантажено з YAML."
      list_expenses
    else
      puts "Файл YAML не знайдено."
    end
  end
end

ExpenseManager.new.run
