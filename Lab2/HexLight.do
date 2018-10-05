vlib work

vlog -timescale 1ns/1ns HexLight.v

vsim HexLight

log {/*}

add wave {/*}

force {Input[3]} 1
force {Input[2]} 0
force {Input[1]} 1
force {Input[0]} 0
run 10ns

force {Input[3]} 1
force {Input[2]} 0
force {Input[1]} 1
force {Input[0]} 1
run 10ns

force {Input[3]} 1
force {Input[2]} 1
force {Input[1]} 0
force {Input[0]} 0
run 10ns

force {Input[3]} 0
force {Input[2]} 0
force {Input[1]} 0
force {Input[0]} 1
run 10ns

force {Input[3]} 0
force {Input[2]} 0
force {Input[1]} 1
force {Input[0]} 0
run 10ns

force {Input[3]} 0
force {Input[2]} 0
force {Input[1]} 1
force {Input[0]} 1
run 10ns

#15 -> F
force {Input[3]} 1
force {Input[2]} 1
force {Input[1]} 1
force {Input[0]} 1
run 10ns

#14 -> E
force {Input[3]} 1
force {Input[2]} 1
force {Input[1]} 1
force {Input[0]} 0
run 10ns