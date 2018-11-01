vlib work

vlog -timescale 1ns/1ns Lab6P1.v

vsim Lab6P1

log {/*}

add wave {/*}

# Synchronous active low resetn
force {SW[0]} 0 0, 1 15

# input w
force {SW[1]} 0 0, 1 48, 0 133, 1 153, 0 173

# clock signal
force {KEY[0]} 1 0, 0 10 -r 20

run 200ns