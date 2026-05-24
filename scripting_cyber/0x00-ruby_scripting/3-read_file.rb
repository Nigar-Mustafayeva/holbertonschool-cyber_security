require 'json'

def count_user_ids(path)
  file    = File.read(path)
  data    = JSON.parse(file)
  counts  = Hash.new(0)

  data.each do |entry|
    counts[entry["userId"]] += 1
  end

  counts.sort.each do |user_id, count|
    puts "#{user_id}: #{count}"
  end
end
