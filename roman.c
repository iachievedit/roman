#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//
// Copyright 2023 iAchieved.it LLC 
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is furnished to do
// so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


// Inspired by https://medium.com/@tomas.langkaas/eight-algorithms-for-roman-numerals-b06c83db12dd
// and algorithm 2 'Coin change and lookup tables'

// Our assembly version
void convert_to_roman(uint16_t x, char* roman);

const char* letters[] = {
    "M", "CM", "D", "CD",
    "C", "XC", "L", "XL",
    "X", "IX", "V", "IV",
    "I"
};

const uint16_t lookupValues[] = {
    1000, 900, 500, 400,
     100,  90,  50,  40,
      10,   9,   5,   4,
       1
};

void to_roman(uint16_t x, char* roman) {

  *roman = '\0';

  for (int index = 0; x; index++) {
    while (x >= lookupValues[index]) {
      x -= lookupValues[index];

      strcat(roman, letters[index]);      
    }
  }

  printf("x = %d\n", x);
  
}

int main(int argc, char* argv[]) {

  const uint16_t x = atoi(argv[1]);
  char roman[16];

  convert_to_roman(x, roman);

  printf("%d in Roman numerals is %s.\n", x, roman);

}