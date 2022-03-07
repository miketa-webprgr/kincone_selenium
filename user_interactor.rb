require 'active_support/all'

class UserInteractor
  YES = ['Y', 'y'].freeze
  NO  = ['N', 'n'].freeze

  attr_accessor :yes_or_no # NOTE: [string型] 'Y', 'y', 'N', 'n'のいずれか
  attr_accessor :year # NOTE: [integer型] 2022の形式
  attr_accessor :month # NOTE: [integer型] 3, 11といった形式
  attr_accessor :rest_start # NOTE: [string型] '12:00'の形式
  attr_accessor :rest_end # NOTE: [string型] '13:00'の形式
  attr_accessor :should_override # NOTE: [boolean型]

  #= Asking_methos
  def ask_yes_or_no
    store_yes_or_no
    ask_yes_or_no until passes_validate_yes_or_no?
  end

  def ask_year
    store_year
    ask_year until passes_validate_year?
  end

  def ask_month
    store_month
    ask_month until passes_validate_year?
  end

  def ask_rest_start
    store_rest_start
    ask_rest_start until passes_validate_rest_start?
  end

  def ask_rest_end
    store_rest_end
    ask_rest_end until passes_validate_rest_end?
  end

  #= Storing_methods
  def store_yes_or_no
    self.yes_or_no = gets.chomp.to_s
  end

  def store_date_of_last_month
    self.year = Time.current.last_month.year
    self.month = Time.current.last_month.month
  end

  def store_year
    self.year = gets.chomp.to_i
  end

  def store_month
    self.month = gets.chomp.to_i
  end

  def store_rest_start
    self.rest_start = gets.chomp.to_s
  end

  def store_rest_end
    self.rest_end = gets.chomp.to_s
  end

  def store_should_override
    boolean = yes? ? true : false
    self.should_override = boolean
  end

  #= Validations
  def passes_validate_yes_or_no?
    yes? || no?
  end

  def passes_validate_year?
    year.is_a?(Integer) && (2000 <= year && year <= 2099)
  end

  def passes_validate_month?
    month.is_a?(Integer) && (1 <= month && month <= 12)
  end

  def passes_validate_rest_start?
    passes_validate_time?(rest_start)
  end

  def passes_validate_rest_end?
    passes_validate_time?(rest_end) && rest_start_earlier_than_rest_end?
  end

  #= Helper
  def yes?
    YES.include?(yes_or_no)
  end

  def no?
    NO.include?(yes_or_no)
  end

  def passes_validate_time?(time)
    regexp = /^(2[0-3]|[01]?[0-9]):([0-5]?[0-9])$/    
    time.is_a?(String) && regexp.match?(time) 
  end

  def rest_start_earlier_than_rest_end?
    rest_start_parsed = Time.parse(rest_start)
    rest_end_parsed = Time.parse(rest_end)
    
    rest_start_parsed < rest_end_parsed
  end
end