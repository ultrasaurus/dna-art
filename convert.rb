root_name = ARGV[0]

if root_name.nil?
  puts "please specify root filename, like: ruby convert.rb ../Pseudomonas-sequence"
  exit
end

read_filename = "#{root_name}.fasta"
newfilename = "#{root_name}.raw"

File.open(read_filename, 'r') do |rfile|
  File.open(newfilename, 'w') do |newfile|
    rfile.readline
    rfile.each do |line|
      puts line
      newfile << line.chomp
    end
  end
end

