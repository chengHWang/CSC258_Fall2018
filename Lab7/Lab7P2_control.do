vlib work
vlog -timescale 1ns/1ns Lab7P2.v
vsim control
log {/*}
add wave {/*}

#clk
force {clk} 0 0, 1 5 -r 10

#reset
force {ld} 0
force {draw} 0
force {reset_n} 0
run 15ns
force {reset_n} 1


force {ld} 1
run 50ns
force {ld} 0
run 50ns

force {ld} 1
run 50ns
force {ld} 0
run 50ns


force {draw} 1
run 50ns
force {draw} 0
run 50ns

run 100ns