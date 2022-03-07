require 'selenium-webdriver'

class KinconeChrome
  attr_accessor :year, :month, :rest_start, :rest_end, :should_override

  def initialize(year, month, rest_start, rest_end, should_override = false)
    @driver = Selenium::WebDriver.for(:chrome)
    @driver.manage.timeouts.implicit_wait = 10

    @year, @month = year, month
    @rest_start, @rest_end = rest_start, rest_end
    @should_override = should_override
  end

  def login
    @driver.navigate.to 'https://kincone.com/auth/login'
    type_in_email_and_password_then_submit
  end

  def redirect_to_calendar
    month_in_two_digits = sprintf("%02d", @month)
    @driver.navigate.to "https://kincone.com/attendance?year=#{@year}&month=#{month_in_two_digits}"
  end

  def click_edit_button(workdate)
    year, month, day = workdate.year, workdate.strftime('%m'), workdate.strftime('%d')

    edit_button = @driver.find_element(:id, "attendance-row-#{year}-#{month}-#{day}").find_element(:class, 'edit-button')
    edit_button.click
  end

  def click_kyukei_button
    add_kyukei_button = @driver.find_element(:id, 'outings').find_element(:class, 'outing_add')
    add_kyukei_button.click
  end

  def delete_kyukei_form
    delete_form_buttons = @driver.find_elements(:class, 'outing_delete')
    delete_form_buttons.last.click
  end

  def has_submitted_kyukei?
    delete_form_buttons = @driver.find_elements(:class, 'outing_delete')
    delete_form_buttons.size >= 2
  end

  def rest_start_earlier_than_attendance_time?
    attendance_time = @driver.find_element(:id, 'start_hours').attribute('value')
    return false if attendance_time.blank?

    Time.parse(rest_start) < Time.parse(attendance_time)
  end

  def rest_end_later_than_leaving_time?
    leaving_time = @driver.find_element(:id, 'end_hours').attribute('value')
    return false if leaving_time.blank?

    Time.parse(rest_end) > Time.parse(leaving_time)
  end

  def submit_kyukei
    kyukei_start_forms = @driver.find_elements(:class, 'outing_out')

    kyukei_start_form = kyukei_start_forms.first.find_element(:id, 'out_hours_0')
    kyukei_start_form.clear
    kyukei_start_form.send_keys(@rest_start)
  
    kyukei_end_form = @driver.find_element(:id, 'in_hours_0')
    kyukei_end_form.clear
    kyukei_end_form.send_keys(@rest_end)
  
    submit_button = @driver.find_element(:xpath, '//*[@id="form-attendance-edit"]/div[12]/div[2]/button')
    submit_button.click
  
    submit_confirm_button = @driver.find_element(:xpath, ' //*[@id="form-attendance-confirm"]/div[13]/div[2]/button')
    submit_confirm_button.click
  end

  private

  def type_in_email_and_password_then_submit
    email_form = @driver.find_element(:id, 'email')
    email_form.send_keys(ENV.fetch('EMAIL'))

    password_form = @driver.find_element(:id, 'password')
    password_form.send_keys(ENV.fetch('PASSWORD'))

    submit_button = @driver.find_element(:xpath, "//*[@id='content']/div[2]/div/div/div[2]/div/form/div[5]/div[2]/input")
    submit_button.click
  end
end
