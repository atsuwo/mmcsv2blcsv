# -*- coding: utf-8 -*-
#
# メディアマーカーの CSV をブクログ形式にするやつ
# 使い方
#   ruby mmcsv2blcsv.rb mm.csv bl.csv
# 参考
#   https://qiita.com/shizuma/items/7719172eb5e8c29a7d6e

require 'csv'

# CSVファイルのパスを指定
ipath = ARGV[0]
opath = ARGV[1]

puts 'start...'
puts 'input ' + File.basename(ipath)

intro_csv = CSV.generate do |csv|
  CSV.foreach(ipath, encoding: 'CP932:UTF-8', headers: true) do |row|
    servece_id = 1
    state = case row['status']
            when '未読' then '積読'
            when '読中' then 'いま読んでる'
            when '読了' then '読み終わった'
            else            '読みたい'
            end
    memo = ''
    ary = [servece_id, row['asin'], row['isbn'], row['category'], row['asset'], state, row['comment'], row['tag'].gsub(/\n/, ','), memo, row['buyday'] + ' 00:00:00', row['readday']]
    csv << ary
    #p row['tag'].gsub(/\n/, ',')
  end
end

File.open(opath, 'w') do |file|
  file.write(intro_csv.encode('CP932'))
end

puts 'complete! See ' + opath

