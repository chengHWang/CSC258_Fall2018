vlib work
vlog -timescale 1ns/1ns FullAdder4Bits.v
vsim fulladder4
log {/*}
add wave {/*}

#0001+0001 +0 = 00010
force {InputA[3]} 0
force {InputA[2]} 0
force {InputA[1]} 0
force {InputA[0]} 1

force {InputB[3]} 0
force {InputB[2]} 0
force {InputB[1]} 0
force {InputB[0]} 1

force {Ci} 0
run 10ns

#0011+0001 +0 = 00100
force {InputA[3]} 0
force {InputA[2]} 0
force {InputA[1]} 1
force {InputA[0]} 1

force {InputB[3]} 0
force {InputB[2]} 0
force {InputB[1]} 0
force {InputB[0]} 1

force {Ci} 0
run 10ns

#0100+0001 +1 = 00110
force {InputA[3]} 0
force {InputA[2]} 1
force {InputA[1]} 0
force {InputA[0]} 0

force {InputB[3]} 0
force {InputB[2]} 0
force {InputB[1]} 0
force {InputB[0]} 1

force {Ci} 1
run 10ns

#1000+1000 +1 = 10001
force {InputA[3]} 1
force {InputA[2]} 0
force {InputA[1]} 0
force {InputA[0]} 0

force {InputB[3]} 1
force {InputB[2]} 0
force {InputB[1]} 0
force {InputB[0]} 0

force {Ci} 1
run 10ns

