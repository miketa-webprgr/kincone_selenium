require 'active_support/all'
require 'dotenv/load'
require 'byebug'
require './user_interactor'
require './kincone_submitter'
require './starter_helper'

include StarterHelper

interactor = UserInteractor.new

set_email if ENV['EMAIL'].blank?
set_password if ENV['PASSWORD'].blank?

puts "\nkinconeの休憩時間自動入力アプリです。\n"
puts "\nkinconeの自動入力を開始しますか？(Y)"
puts "\マニュアルを確認しますか？(N)"
interactor.ask_yes_or_no

if interactor.no?
  show_manual 
  exit
end

interactor.yes_or_no = nil # resetする

puts "\n先月の休憩時間を入力しますか？（Y/N）"
interactor.ask_yes_or_no

if interactor.no?
  puts "\n何年の休憩時間を自動入力しますか？（2022年の場合、2022と入力）"
  interactor.ask_year

  puts "\n何月の休憩時間を自動入力しますか？（1月の場合、1と入力）"
  interactor.ask_month
else
  interactor.store_date_of_last_month 
end
interactor.yes_or_no = nil # resetする

puts "\n休憩時間の開始時間（24時間表記）はいつにしますか？（12時の場合、12:00と入力）"
interactor.ask_rest_start

puts "\n休憩時間の終了時間（24時間表記）はいつにしますか？（13時の場合、13:00と入力）"
interactor.ask_rest_end

puts "\n入力済みの休憩時間を上書きしますか？（Y/N）"
interactor.ask_yes_or_no
interactor.store_should_override
interactor.yes_or_no = nil # resetする

puts "\n以下のとおりでお間違いないですか？（Y/N）"
puts "Yと回答した場合、自動入力が開始します。Nと回答した場合、プログラムの実行を中止します。"
puts "========================================================"
puts "年: #{interactor.year}"
puts "月: #{interactor.month}"
puts "休憩開始: #{interactor.rest_start}"
puts "休憩終了: #{interactor.rest_end}"
puts "上書き: #{interactor.should_override}"
puts "========================================================"
interactor.ask_yes_or_no

if interactor.yes?
  submitter = KinconeSubmitter.new(interactor)
  submitter.submit
else
  exit
end
interactor.yes_or_no = nil # resetする