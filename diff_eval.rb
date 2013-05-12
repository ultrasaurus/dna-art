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

  summary << {file:newfilename, height:height, length:count}
  seq_num += 1
end

puts "root_name:#{root_name} width:#{width}"
puts summary
puts "------------------------------------------"
data = summary.map { |s| File.read(s[:file]).split(//) }
# now we have an array of arrays of bases

puts data.length
zipped = data[0].zip(*(data.drop(1)))
#puts zipped[0].join

diff_list = [0,0,0,0]
diff_count = 0
zipped.each do |element|
  puts element.join
  element.delete("N")
  diff_list[diff_count] += 1
  #puts element.uniq.length
  #puts diff_count % 1 == 1
  
  if (element.uniq.length > 1) and (diff_count % 1 == 1)
    puts "==============> different"
    diff_count += 1
  elsif (element.uniq.length == 1) and (diff_count % 1 == 0)
    puts "==============> same"
    diff_count += 1
  end
  break if diff_list[diff_count].nil?
end

puts diff_list



