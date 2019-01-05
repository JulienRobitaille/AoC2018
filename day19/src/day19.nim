import strutils, sequtils, tables, math

type Instruction = object
        opcode: string
        A: int #Input
        B: int #Input
        C: int #Output

func parseInstructions(line: string): Instruction =
    let elements = line.splitWhitespace
    result = Instruction(opcode: elements[0], A: elements[1].parseInt, B: elements[2].parseInt, C: elements[3].parseInt)

const 
    input = "src/input.txt".readFile.splitLines
    #input = "src/test.txt".readFile.splitLines
    controlFlowRegister = ($input[0][^1]).parseInt
    seedValueRegister = ($input[^3][^1]).parseInt
    instructions = input[1..input.len - 1].mapIt(parseInstructions(it))

var 
    registers = @[0, 0, 0, 0, 0, 0]
    instructionPointer = 0
    opcodes = {
        "addr": proc(a:int, b:int, c:int) = registers[c] = registers[a] + registers[b],
        "addi": proc(a:int, b:int, c:int) = registers[c] = registers[a] + b,
        "mulr": proc(a:int, b:int, c:int) = registers[c] = registers[a] * registers[b],
        "muli": proc(a:int, b:int, c:int) = registers[c] = registers[a] * b,
        "banr": proc(a:int, b:int, c:int) = registers[c] = registers[a] and registers[b],
        "bani": proc(a:int, b:int, c:int) = registers[c] = registers[a] and b,
        "borr": proc(a:int, b:int, c:int) = registers[c] = registers[a] or registers[b],
        "bori": proc(a:int, b:int, c:int) = registers[c] = registers[a] or b,
        "setr": proc(a:int, b:int, c:int) = registers[c] = registers[a],
        "seti": proc(a:int, b:int, c:int) = registers[c] = a,
        "gtir": proc(a:int, b:int, c:int) = registers[c] = if a > registers[b]: 1 else: 0,
        "gtri": proc(a:int, b:int, c:int) = registers[c] = if registers[a] > b: 1 else: 0,
        "gtrr": proc(a:int, b:int, c:int) = registers[c] = if registers[a] > registers[b]: 1 else: 0,
        "eqir": proc(a:int, b:int, c:int) = registers[c] = if a == registers[b]: 1 else: 0,
        "eqri": proc(a:int, b:int, c:int) = registers[c] = if registers[a] == b: 1 else: 0,
        "eqrr": proc(a:int, b:int, c:int) = registers[c] = if registers[a] == registers[b]: 1 else: 0
    }.toTable
    
proc computeSeed(r: seq[int]): int =
    registers = r
    instructionPointer = 0
    while instructionPointer <= instructions.len - 1:
        let 
            instruction = instructions[instructionPointer]
        # Bind value of instruction pointer to register
        registers[controlFlowRegister] = instructionPointer
        
        #Execute the instruction
        opcodes[instruction.opcode](instruction.A, instruction.B, instruction.C)
        instructionPointer = registers[controlFlowRegister] + 1
        #Break at 2 because it is where the program start computing the result
        #And we will compute it ourself
        if instructionPointer == 2:
            break
    result = registers[seedValueRegister]

func computeSumOfDivisor(target: int): int =  
    for i in 1 .. target:
        if target mod i == 0:
            result = result + i

let 
    part1Seed = computeSeed(@[0, 0, 0, 0, 0, 0])
    part2Seed = computeSeed(@[1, 0, 0, 0, 0, 0])

echo "Part 1: ", computeSumOfDivisor(part1Seed)    
echo "Part 2: ", computeSumOfDivisor(part2Seed)

