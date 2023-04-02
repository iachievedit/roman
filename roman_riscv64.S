#
# Copyright 2023 iAchieved.it LLC 
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

.global convert_to_roman

.data

lookup_values:   .int  1000,  900, 500, 400,  100,  90,   50,   40,  10,    9,   5,    4,   1
roman_numerals:  .asciz "M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"

.text

convert_to_roman:

  addi sp,sp,-48
  sd   ra,0(sp)
  sd   s1,8(sp)
  sd   s2,16(sp) # currently unused
  sd   s3,24(sp) # index for lookup
  sd   s4,32(sp)
  sd   s5,40(sp)

  la   s1,lookup_values     
  mv   s2,a1                # pointer to buffer to fill with chars
  li   s3,0                 # initialize index

  mv   s5,a0                # s5 <- number

again:
  lh   s4,0(s1)             # s4 <- lookup_values[index]

1:
  blt  s5,s4,2f             # number >= lookup_values[index]? 
  j    get_chars_and_cat    # get index and concat
  
2:                          
  beq  s5,zero,done         # number = 0?
  addi s1,s1,4              # increment index for value lookup
  addi s3,s3,1              # increment index for char lookup
  j    again

get_chars_and_cat:
  sub  s5,s5,s4             # decrement number by lookup_values[index]

  mv  a0,s3                 # index_to_roman(index)
  jal index_to_roman_chars

  mv   a0,s2

  call strcat               # a0 - buffer to fill, a1 - ptr to numeral
  
  j 1b

done:
  ld   s5,40(sp)
  ld   s4,32(sp)
  ld   s3,24(sp)
  ld   s2,16(sp)
  ld   s1,8(sp)
  ld   ra,0(sp)
  addi sp,sp,48

  ret

#
# Takes an index in a0 and returns a pointer
# to a null-terminated char string in a1
#
index_to_roman_chars:
  addi sp,sp,-32
  sd   ra,0(sp)
  sd   s1,8(sp)
  sd   s2,16(sp)
  sd   s3,24(sp)

  la   s1,roman_numerals # our list of Roman numerals
  mv   s2,a0             # s2 - nth entry in the list to find (zero indexed)
  li   s3,0              # loop counter

  bne  a0,zero,inc       # index not zero?
  mv   a1,s1             # base case, index = 0
  j    index_found

inc:
  lb   t6,0(s1)          # load character
  addi s1,s1,1           # move to next character in array
  bnez t6,inc            # character not NULL? keep going
  addi s3,s3,1           
  bne  s2,s3,inc         # if we aren't at the string we want, keep going
  mv   a1,s1             # s1 points to Roman numeral we want

index_found:
  ld   s3,24(sp)
  ld   s2,16(sp)
  ld   s1,8(sp)
  ld   ra,0(sp)
  addi sp,sp,32
  ret