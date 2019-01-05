# Day 19: Go With The Flow

For part one, I ran the small program in my interpreter.

Today part 2 was really hard. Big thanks to [Martijn Pieters](https://nbviewer.jupyter.org/github/mjpieters/adventofcode/blob/master/2018/Day%2019.ipynb)
for making an awesome explanation

After reading Martijn Pieters work I tried to understand my input data

For part two I wrote a function to compute the answer
It's basically a re-implementation of the program bellow but faster.
I annotated the program to help me understand what he was doing.

r[number] refer to registers[number].

r0 = register at position 0

r2 was my register position and r4 is where the seed is computed.

### Initial line
    addi 2 16 2 # r2 = r2 + 16 ( 1 + 16 = 17) # Bring you to line 17
### First loop    
    seti 1 0 1 # r1 = 1
    seti 1 3 3 # r3 = 1 
### Second loop
        mulr 1 3 5 # r5 = r1 * r3
        eqrr 5 4 5
        addr 5 2 2 
        addi 2 1 2
### This is the part the algo will add to r0 thr result in r1 and what was in r0 (It make a sum)
        addr 1 0 0
        addi 3 1 3
        gtrr 3 4 5
        addr 2 5 2
        seti 2 6 2 # GO TO LINE 2
### The rest of loop one
    addi 1 1 1
    gtrr 1 4 5
    addr 5 2 2
    seti 1 1 2
### Stop the program
    mulr 2 2 2
### This generate the seed number
    addi 4 2 4 r4 = r4 + 2 r4 = 2 
    mulr 4 4 4 r4 = r4 * r4 = 4
    mulr 2 4 4 r4 = r2 * r4 = 19 * 4
    muli 4 11 4 r4 =  r4 * 11 = 76 * 11 = 836
    addi 5 6 5 r5 = r5 + 6 
    mulr 5 2 5 r5 = r5 * r2 = 6 * 22 = 132
    addi 5 19 5 r5 = r5 + 19 = 151
    addr 4 5 4 r4 = r4 + r5 # @[0, 0, 24, 0, 987, 151]
### r2 = r2 + r0 (this make us skip next line if r0 == 1 (part 2))
    addr 2 0 2 r2 = r2 + r0
### if r0 == 0 skip to solving
    seti 0 7 2 r2 = 0
### Here the algo make it grow way bigger for part two
    setr 2 6 5 r5 = r2 + r6
    mulr 5 2 5
    addr 2 5 5
    mulr 2 5 5
    muli 5 14 5
    mulr 5 2 5
    addr 4 5 4
    seti 0 7 0 r0 = 0 
### JUMP TO START
    seti 0 3 2 # r2 = 0 