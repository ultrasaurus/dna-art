read_filename = "Pseudomonas-sequence.fasta"
newfilename = "Pseudomonas-sequence.raw"

File.open(read_filename, 'r') do |rfile|
  File.open(newfilename, 'w') do |newfile|
    rfile.readline
    rfile.each do |line|
      puts line
      newfile << line.chomp
    end
  end
end

