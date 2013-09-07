nums = {}

STDIN.read.split(/\n/).each do |line|
	code, num, e = line.split(/\t/)

	nums[code] = num.to_i if num.to_i != 0
end

puts "instance Enum ISO4217Currency where"
nums = nums.to_a.sort {|(code1,num1),(code2,num2)| num1 <=> num2 }

nums.each do |(code, num)|
	if code[0] == 'X'
		puts "\tfromEnum (NonNationalCurrency '#{code[1]}' '#{code[2]}')     = #{num}"
	else
		puts "\tfromEnum (NationalCurrency Country.#{code[0..1]} '#{code[2]}') = #{num}"
	end
end

puts

nums.each do |(code, num)|
	if code[0] == 'X'
		puts "\ttoEnum #{num} = NonNationalCurrency '#{code[1]}' '#{code[2]}'"
	else
		puts "\ttoEnum #{num} = NationalCurrency Country.#{code[0..1]} '#{code[2]}'"
	end
end
