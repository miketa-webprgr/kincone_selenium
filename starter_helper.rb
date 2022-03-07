module StarterHelper
  def set_email
    puts "\nkinconeログイン用のemailを入力してください"
    puts "入力した値は、暗号化等されることなく「.env」に保存されます。"

    email = gets.chomp.to_s
    set_email if email.blank?

    File.open(".env", mode = "a") { |f| f.write("EMAIL=#{email}\n") }
  end

  def set_password
    puts "\nkinconeログイン用のpasswordを入力してください"
    puts "入力した値は、暗号化等されることなく「.env」に保存されます。"

    password = gets.chomp.to_s
    set_password if password.blank?

    File.open(".env", mode = "a") { |f| f.write("PASSWORD=#{password}\n") }
  end

  def show_manual
    puts "\n\n==============================================================="
    puts "kinconeでは、休憩時間を逐一入力しなければいけません。。。\n\n"
    puts "このプラグラムは、そんな面倒なあなたのために作られたものです。"
    puts "Seleniumを活用し、１ヶ月分の休憩時間を自動入力してくれます！\n\n"
    puts "例えば、2022年の1月の休憩時間を「12:00から13:00」とまとめて入力したい場合、"
    puts "1. 対象となる年月"
    puts "2. 自動入力する休憩時間"
    puts "以上を入力すれば、1分弱で自動入力をしてくれます。\n\n"
    puts "なお、休憩時間が既に入力されている場合、その日の入力はスキップされます。"
    puts "上書きしたい場合、オーバーライドのオプションをオンにすることで対応できます。\n\n"
    puts "なお、kinconeの画面レイアウトに大きく依存したプログラムです。"
    puts "すぐ動かなくなるかもしれません。。。 ご承知おきください\n\n"
    puts "すえどみ"
    puts "==============================================================="
  end
end

