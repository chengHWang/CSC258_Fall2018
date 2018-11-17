vlib work
vlog -timescale 1ns/1ns Lab7P2.v
vsim test_module
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


#load x
force {position[6]} 1
force {position[5]} 0
force {position[4]} 1
force {position[3]} 0
force {position[2]} 0
force {position[1]} 1
force {position[0]} 1
run 50ns
force {ld} 1
run 50ns
force {ld} 0
run 50ns


#load y
force {position[6]} 0
force {position[5]} 0
force {position[4]} 0
force {position[3]} 0
force {position[2]} 1
force {position[1]} 1
force {position[0]} 1
run 50ns
force {ld} 1
run 50ns
force {ld} 0
run 50ns


#load color
force {color_in[2]} 1
force {color_in[1]} 0
force {color_in[0]} 1
run 50ns
force {draw} 1
run 50ns
force {draw} 0
run 50ns


run 100ns