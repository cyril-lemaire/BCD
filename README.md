# BCD Pascal Program

**Installation Process:** Well I do not know how to make an automatic compiler like a Makefile in Pascal so I'll let you just compile BCD.pas yourself. Since Pascal compilers are getting quite rare I'm adding out a BCD.exe for the lazy and clumsy dudes using Nyandows :3
___
**Usage:** Simulate seven-segments displays with variable size in the terminal to print any input number at the requested size (the size is given as segment length, not exactly digit width).
       The program handles carriage returns and smooth big shapes, but requires the width of a digit to stay under 80 (returns an error otherwise)
___
**BONUS part:** Simulate a clock at the requested size with the requested refresh rate (/!\ That clock doesn't use any buffer and thus flickers quite a lot on low refresh rates. The author shall not be held responsible in case of epilepsy ;P)