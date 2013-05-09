require 'chunky_png'

root_name = ARGV[0]

if root_name.nil?
  puts "please specify root filename, like: ruby convert.rb ../Pseudomonas-sequence"
  exit
end

read_filename = "#{root_name}.fasta"
png_filename = "#{root_name}.png"
txt_filename = "#{root_name}.png"

png[1,1] = ChunkyPNG::Color.rgba(10, 20, 30, 128)
png[2,1] = ChunkyPNG::Color('black @ 0.5')
png.save('filename.png', :interlace => true)

png = nil
size = 0

File.open(read_filename, 'r') do |rfile|
  size = rfile.size
  info = rfile.readline
  size = size - info.length
  File.open(text_filename, 'w') do |newfile|
    text_filename << info
  end
  width = 900   # 3 inches on 300 dpi
  height = (size / width) + 1
  png = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::TRANSPARENT)  

  File.open(new_filename, 'w') do |newfile|
    rfile.each do |line|
      puts line
      newfile << line.chomp
    end
  end
end

