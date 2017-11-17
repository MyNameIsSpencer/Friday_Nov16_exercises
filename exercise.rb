

def counter(str)
  return str.split.count
end



stringer_a = 'This is a sentence where Doctor Fantastic met the King of Mars.'
# puts stringer_a.split.count
puts '=' * 20

puts counter(stringer_a)
puts counter("Howdee do, what's yhour narm?")
puts '=' * 20
