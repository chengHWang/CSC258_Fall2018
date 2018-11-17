vlib work
vlog -timescale 1ns/1ns Lab7P1.v
vsim -L altera_mf_ver ram32x4
log {/*}
add wave {/*}

#clk
force {clock} 0 0, 1 5 -r 10

#address
force {address[4]} 1
force {address[3]} 0
force {address[2]} 1
force {address[1]} 0
force {address[0]} 0

#datain
force {data[3]} 0
force {data[2]} 1
force {data[1]} 0
force {data[0]} 0

#enable
force {wren} 1
run 15

force {wren} 0
run 15

force {data[3]} 0
force {data[2]} 1
force {data[1]} 1
force {data[0]} 1
run 10

force {wren} 1
run 10
