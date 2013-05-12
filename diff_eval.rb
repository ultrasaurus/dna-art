root_name = ARGV[0]
seq_start = ARGV[1]
width = ARGV[2]

if root_name.nil? || seq_start.nil?
  puts "please specify root filename and starting sequence number, like: ruby diff_eval.rb ../Pseudomonas-sequence 29"
  exit
end

seq_start = seq_start.to_i

def read_filename(*args)
  name, num = args
  unless name.nil? and num.nil?
    @read_filename = "#{name}#{num}.fasta"
  end
  @read_filename
end

seq_num = seq_start
puts "reading file: #{read_filename}"
summary = []

while (File.exist?(read_filename(root_name, seq_num))) do
  puts "reading #{read_filename}"
  height = 0
  count = 0
  str = ""
  newfilename = "#{root_name}#{seq_num}.raw"
  File.open(read_filename, 'r') do |rfile|
    File.open(newfilename, 'w') do |newfile|
      rfile.readline
      rfile.each do |line|
        line.upcase!
        line.chomp!
        count += line.length
        putc ('.')
        newfile << line
        str << line
      end

      unless width.nil?
        width = width.to_i
        trailing_line_length = count % width
        padding_count = width - trailing_line_length
        padding = "X" * padding_count
        newfile << padding

        count += padding_count
        height = count / width
      end


    end
    puts ""
  end

  summary << {file:newfilename, height:height, length:count, bases_str:str}
  seq_num += 1
end

puts "root_name:#{root_name} width:#{width}"

# sort by differences in the 7th base of each sequence (visually inspected for significance)
summary.sort_by! { |s| s[:bases_str][7] }
summary.each do |s|
  puts "#{s[:file]}: height=#{s[:height]} length=#{s[:length]}"
end

puts "------------------------------------------"
data = summary.map { |s| s[:bases_str].split(//) }
# now we have an array of arrays of bases


puts data.length
zipped = data[0].zip(*(data.drop(1)))
#puts zipped[0].join

list = []
diff_count = 0
was_same = false
match_length = 0

zipped.each do |element|
  puts element.join
  element.delete("N")
  list[diff_count] ||= {start:0, stop:0}
  count = list[diff_count]
  count[:stop] += 1

  len = count[:stop] - count[:start]
  if (element.uniq.length > 1) and was_same
    was_same = false
    puts "========================================== different"
    if ( match_length <= 16 ) # reset
      diff_count -= 1
      count = list[diff_count]
      count[:stop] += 1
      puts "stop:#{count[:stop]}  start:#{count[:start]}"
    else
      puts "stop:#{count[:stop]}  start:#{count[:start]}"
      new_start = count[:stop] + 1
      diff_count += 1
      list[diff_count] = {start:new_start, stop:new_start}
    end
  elsif (element.uniq.length == 1)
    puts "========================================== same"
    if was_same
      match_length += 1
    else
      match_length = 0
      was_same = true
      
      puts "stop:#{count[:stop]}  start:#{count[:start]} len:#{match_length}"
      new_start = count[:stop] + 1
      diff_count += 1
      list[diff_count] = {start:new_start, stop:new_start}
    end
  end
end

puts "============ list ==============="
puts list



