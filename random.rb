# # def range(start_num, end_num)
# #     return [] if start_num > end_num #1
# #     return [start_num] if start_num == (end_num - 1) # 2
# #     range(start_num + 1, end_num) << (start_num) # 3
# # end

# def range(start_num, end_num)
#     return [start_num] if start_num > end_num - 1
#     range(start_num, end_num - 1) << end_num
# end

# #1  no need to do any work, if start is bigger than end
# #2  right when start num is 1 less then end num return; no longer worry about 5
# #3  I rather increment num if going in this order, decrement end if going in opposite order.

# p range(1,5)


def reverse(word)
i = 0
 chars = ""
 while i < word.length
     k = (word.length - 1) - i 
   char = word[k]
   chars+=char
   i+=1
 end
 return chars
end


puts reverse("cat")          # => "tac"
puts reverse("programming")  # => "gnimmargorp"
puts reverse("bootcamp")     # => "pmactoob"


