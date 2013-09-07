units = {}

STDIN.read.split(/\n/).each do |line|
	code, num, e = line.split(/\t/)

	units[code] = e.to_i if e && e != '.'
end

puts "minorUnits :: ISO4217Currency -> Maybe Int"

units.each do |(code, units)|
	if code[0] == 'X'
		puts "minorUnits (NonNationalCurrency '#{code[1]}' '#{code[2]}')     = Just #{units}"
	else
		puts "minorUnits (NationalCurrency Country.#{code[0..1]} '#{code[2]}') = Just #{units}"
	end
end

puts "minorUnits _ = Nothing"
