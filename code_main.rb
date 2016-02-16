require_relative 'dictionary/word_list.rb'
require_relative 'subdata/treeoflife.rb'

# Methods

def word_hasher(string)
	string.split("\n").reduce(Hash.new) do |hash, kv|
    kv2 = kv.split("\t")
    hash[kv2[0]] = kv2[1].to_i
    hash
	end
end

def parse_time(time_str)
	time = time_str.split(":")
	hour = time[0]
	min = time[1]
	secs = time[2][0..1]
	hour_secs = hour.to_i * 3600
	min_secs = min.to_i * 60
	secs = secs.to_i
	hour_secs + min_secs + secs
end

def cleaner(str)
	str.split("").map do |letter|
		if letter =~ /[^a-zA-Z]/
			""
		else
			letter.downcase
		end
	end.join("")
end

def score(arr, word_hash)
	total = 0
	arr.each do |word|
		clean_word = cleaner(word)
		if word_hash[clean_word]
			total += word_hash[clean_word]
		end
	end
	total
end
# Transfer of wordlist, and creation of the word dictionary

words = WordList.new
words = words.words
word_hash = word_hasher(words)

# Transfer of Shawshank subtitles, and the splitting
movie = Treeoflife.new
movie = movie.text
movie_arr = movie.split(/\n+\d+\n+/)


# The main method

result = []

movie_arr[1..-1].each_with_index do |dialogue, idx|
	raw = dialogue.split(" ")
	x_value = parse_time(raw[0])
	p idx
  y_value = score(raw[3..-1], word_hash)
	result << [x_value, y_value]
end

File.open("results/treeoflife.json", 'w') do |file|
	file.puts "var treeoflife_data ="
	file.print result
end


