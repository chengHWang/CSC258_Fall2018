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
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

#reset
force {SW[9]} 0

#clock start to change
force {KEY0} 1
run 10ns
force {KEY0} 0
force {SW[9]} 1
run 10ns

#Stage1 mode000 A+1 20ns-40ns
#A 4'b0001 B 4'b0000 =>  ALUout 8'b0000_0010
#ALUout 8'b0000_0010 =>  A 4'b0001 B 4'b0010
force {KEY0} 1
run 10ns
force {KEY0} 0
#change mode
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 0
run 10ns

#Stage2 mode001 A+B 40ns-60ns
#A 4'b0001 B 4'b0010 => ALUout 8'b0000_0011
#A ALUout 8'b0000_0011 => A 4'b0001 B 4'b0011
force {KEY0} 1
run 10ns
force {KEY0} 0
run 10ns

#Stage3 mode001 A+B 60ns-80ns
#A 4'b0001 B 4'b0011 => ALUout 8'b0000_0100
#A ALUout 8'b0000_0100 => A 4'b0001 B 4'b0100
force {KEY0} 1
run 10ns
force {KEY0} 0
#change mode
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 1
run 10ns

#Stage4 mode005 B<<A 80ns-100ns
#A 4'b0001 B 4'b0100 => ALUout 8'b0000_1000
#A ALUout 8'b0000_1000 => A 4'b0001 B 4'b1000
force {KEY0} 1
run 10ns
force {KEY0} 0
#change mode
force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 1
#change A
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
run 10ns

#Stage5 mode006 B>>A 100ns-120ns
#A 4'b0010 B 4'b1000 => ALUout 8'b0000_0010
#A ALUout 8'b0000_0010 => A 4'b0010 B 4'b0010
force {KEY0} 1
run 10ns
force {KEY0} 0
run 10ns