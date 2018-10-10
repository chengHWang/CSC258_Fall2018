vlib work
vlog -timescale 1ns/1ns Dff.v
vsim dff
log {/*}
add wave {/*}

force {d} 0 0, 1 10 -r 30
force {clk} 0 0, 1 5 -r 10
force {reset_n} 0

run 10ns
force {reset_n} 1
run 10ns
run 10ns
run 10ns
run 10ns
run 10ns
run 10ns
run 10ns




