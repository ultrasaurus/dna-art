root_name = ARGV[0]
width = ARGV[1]

if root_name.nil?
  puts "please specify root filename, like: ruby convert.rb ../Pseudomonas-sequence"
  exit
end

height = 0
count = 0


read_filename = "#{root_name}.fasta"
newfilename = "#{root_name}.raw"

File.open(read_filename, 'r') do |rfile|
  File.open(newfilename, 'w') do |newfile|
    rfile.readline
    rfile.each do |line|
      line.upcase!
      line.chomp!
      count += line.length
      puts line
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
end



puts "root_name:#{root_name} height:#{height} width:#{width}"


