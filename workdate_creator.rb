require 'holiday_jp'
require 'active_support/all'

class WorkdateCreator
  attr_reader :year, :month

  def initialize(year = Time.current.year, month = Time.current.month)
    @year = year
    @month = month
  end

  def monthly_workdates
    monthly_workdates = []
    first_day = 1
    last_day = Time.new(@year, @month).end_of_month.day
   
    (first_day..last_day).each do |day|
      date = Time.new(@year, @month, day)
      next if non_workday?(date)
  
      monthly_workdates << date
    end
  
    monthly_workdates
  end

  private

  def workday?(date)
    (1..5).include?(date.wday) && !HolidayJp.holiday?(date)
  end
  
  def non_workday?(date)
    !workday?(date)
  end
end