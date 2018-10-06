vlib work
vlog -timescale 1ns/1ns Alu_cpu.v
vsim alu_cpu
log {/*}
add wave {/*}

force {mode} 3'b111
force {A} 4'b0001
force {B} 4'b0000
run 20ns