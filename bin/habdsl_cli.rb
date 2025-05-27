#!/usr/bin/env ruby
require_relative "../lib/habdsl/"
require "roo"
require "tty-prompt"
require "dotenv"

Dotenv.load

prompt = TTY::Prompt.new
current_dir = Dir.pwd
EXCEL_EXTENSIONS = [".xls", ".xlsx", ".xlsm"]

selected_file = nil

loop do
  puts "\n現在のディレクトリ: #{current_dir}"

  entries = Dir.entries(current_dir).reject {|e| e == "." }.sort

  display_entries = entries.select do |entry|
    full_path = File.join(current_dir, entry)
    File.directory?(full_path) || EXCEL_EXTENSIONS.include?(File.extname(entry).downcase)
  end

  if display_entries.empty?
    puts "このディレクトリにはExcelファイルもサブディレクトリもありません"
    puts "Enterキーで戻る..."
    gets
    current_dir = File.expand_path("..", current_dir)
    next
  end

  choice = prompt.select("Excelファイルまたはディレクトリを選択:", display_entries)
  full_path = File.expand_path(choice, current_dir)

  if File.directory?(full_path)
    current_dir = full_path
  else
    selected_file = full_path
    puts "\n選択されたExcelファイル: #{selected_file}"
    break
  end
end

puts "Ruby 内部DSLから openHAB の設定DSLを自動生成します．\nDSL CLI モード - 終了するには Ctrl+D または 空行2回. Ctrl+C で処理中止\n\n"

lines = []
empty_line_count = 0

while line = $stdin.gets
  if line.strip.empty?
    empty_line_count += 1
    break if empty_line_count >= 2

    next
  else
    empty_line_count = 0
  end
  lines << line
end

puts "\n出力ファイル名を入力してください（例: my_items.items）:"
print "> "
file_name = $stdin.gets&.strip
file_name = "output.items" if file_name.nil? || file_name.empty?
input_code = lines.join

begin
  output = Habdsl::SheetParser.parse(input_code: input_code, excel_path: selected_file)
  puts output.table
  puts output.dsl
  File.write("output/#{file_name}", output.dsl)
  puts "\n出力完了: output/#{file_name}"
rescue StandardError => e
  puts "エラー発生: #{e.class} - #{e.message}"
  puts e.backtrace.join("\n")
end
