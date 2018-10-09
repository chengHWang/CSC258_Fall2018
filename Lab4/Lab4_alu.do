vlib work
vlog -timescale 1ns/1ns Lab4_alu.v
vsim alu
log {/*}
add wave {/*}

#A
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0

#mode
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 0

#reset
force {SW[9]} 1

#clock start to change
force {KEY0} 1
run 10ns
force {KEY0} 0
force {SW[9]} 0
run 10ns
force {KEY0} 1
run 10ns
force {KEY0} 0
run 10ns
force {KEY0} 1
run 10ns
force {KEY0} 0
run 10ns
#change mod
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 1

force {KEY0} 1
run 10ns
force {KEY0} 0
run 10ns
force {KEY0} 1
run 10ns
force {KEY0} 0
run 10ns
force {KEY0} 1
run 10ns
