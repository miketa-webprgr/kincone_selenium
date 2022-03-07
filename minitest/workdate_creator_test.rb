require 'minitest/autorun'
require 'byebug'
require '../workdate_creator'

describe 'new' do
  it 'stores the date of last month with no arguments' do
    workdate_creator = WorkdateCreator.new

    assert_equal workdate_creator.year, Time.current.year
    assert_equal workdate_creator.month, Time.current.month
  end

  it 'stores the year and the month from arguments' do
    workdate_creator = WorkdateCreator.new(2000, 1)

    assert_equal workdate_creator.year, 2000
    assert_equal workdate_creator.month, 1
  end
end

describe 'monthly_workdates' do
  it 'returns array of monthly workdates' do
    workdate_creator = WorkdateCreator.new(2000, 1)
    monthly_workdates = workdate_creator.monthly_workdates

    # 2000年の1月は、祝日や土日を覗いた勤務日が20日間
    assert_equal monthly_workdates.count, 20 
    # 2000年の1月の祝日は、1月10日であるため、monthly_workdatesに含まれない
    assert_equal monthly_workdates.any? { |workdate| workdate.day == 10 }, false
  end
end

describe 'workday?' do
  it 'returns true when workday is Monday' do
    monday = Time.new(2000, 1, 17)
    raise if monday.wday != 1 # 月曜日であることをチェック
    raise if HolidayJp.holiday?(monday) # 祝日でないことをチェック

    workdate_creator = WorkdateCreator.new
    assert_equal workdate_creator.send(:workday?, monday), true
  end

  it 'returns false when workday is Saturday' do
    saturday = Time.new(2000, 1, 15)
    raise if saturday.wday != 6 # 土曜日であることをチェック
    raise if HolidayJp.holiday?(saturday) # 祝日でないことをチェック

    workdate_creator = WorkdateCreator.new
    assert_equal workdate_creator.send(:workday?, saturday), false
  end

  it 'returns false when workday is Sunday' do
    sunday = Time.new(2000, 1, 16)
    raise if sunday.wday != 0 # 日曜日であることをチェック
    raise if HolidayJp.holiday?(sunday) # 祝日でないことをチェック

    workdate_creator = WorkdateCreator.new
    assert_equal workdate_creator.send(:workday?, sunday), false
  end

  it 'returns true when workday is Holiday' do
    holiday = Time.new(2000, 1, 10)
    raise if holiday.wday == (0 || 6) # 土日でないことをチェック
    raise unless HolidayJp.holiday?(holiday) # 祝日であることをチェック 

    workdate_creator = WorkdateCreator.new
    assert_equal workdate_creator.send(:workday?, holiday), false
  end

  describe 'non_workday?' do
    it 'returns true when workday? is false' do
      date = Time.new

      workdate_creator = WorkdateCreator.new
      workdate_creator.stub :workday?, false do
        assert_equal workdate_creator.send(:non_workday?, date), true
      end
    end

    it 'returns false when workday? is true' do
      date = Time.new

      workdate_creator = WorkdateCreator.new
      workdate_creator.stub :workday?, true do
        assert_equal workdate_creator.send(:non_workday?, date), false
      end
    end
  end
end
