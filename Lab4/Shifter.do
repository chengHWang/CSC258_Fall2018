vlib work
vlog -timescale 1ns/1ns Shifter.v
vsim shifter
log {/*}
add wave {/*}

#the clock signal
force {KEY[0]} 0 0, 1 5 -r 10

#first reset all to 0
force {SW[9]} 0

force {SW[7]} 1
force {SW[6]} 0
force {SW[5]} 1
force {SW[4]} 1
force {SW[3]} 1
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 1
 
force {KEY[1]} 1
force {KEY[2]} 0
force {KEY[3]} 1
run 5ns

#Now load every initial value
force {SW[9]} 1
force {KEY[1]} 0
run 10ns

#Start, ASR on
force {KEY[1]} 1
force {KEY[2]} 1
run 30ns

#Start, ASR off
force {KEY[3]} 0
run 30ns

#Start, ASR off, shiftR off
force {KEY[2]} 0
run 30ns



