vlib work
vlog -timescale 1ns/1ns complete_alu.v
vsim alu
log {/*}
add wave {/*}

#B
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
#A
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0
#KEY
force {KEY[2]} 1
force {KEY[1]} 0
force {KEY[0]} 1
run 20ns