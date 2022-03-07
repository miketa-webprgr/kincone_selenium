require './kincone_chrome'
require './workdate_creator'

class KinconeSubmitter
  def initialize(interactor)
    year, month = interactor.year, interactor.month
    rest_start, rest_end = interactor.rest_start, interactor.rest_end
    should_override = interactor.should_override

    @kincone = KinconeChrome.new(year, month, rest_start, rest_end, should_override)
    @workdate_creator = WorkdateCreator.new(@kincone.year, @kincone.month)
  end

  def submit
    puts '休憩時間の一括入力を始めます'
    @kincone.login
    
    workdates = @workdate_creator.monthly_workdates
    workdates.each do |workdate|
      @kincone.redirect_to_calendar
      @kincone.click_edit_button(workdate)
      @kincone.click_kyukei_button
    
      if @kincone.has_submitted_kyukei? && !@kincone.should_override
        next @kincone.redirect_to_calendar
      end

      if @kincone.has_submitted_kyukei?
        @kincone.delete_kyukei_form 
      end

      if @kincone.rest_start_earlier_than_attendance_time?
        puts "#{workdate.strftime('%Y/%m/%d')}: 出勤開始時間より、休憩開始時間が早くなっているため入力できません"
        next @kincone.redirect_to_calendar
      end

      if @kincone.rest_end_later_than_leaving_time?
        puts "#{workdate.strftime('%Y/%m/%d')}: 退勤時間より、休憩終了時間が遅くなっているため入力できません"
        next @kincone.redirect_to_calendar
      end

      @kincone.submit_kyukei
    
      puts "#{workdate.strftime('%Y/%m/%d')}: 休憩時間を更新"
    end
    
    puts '終了します'
  end
end

