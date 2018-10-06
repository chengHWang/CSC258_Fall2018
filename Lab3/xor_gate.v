module xor_gate(y,a,b);
    input a,b;
    output y;
    assign y = (!a & b) | (a & !b);
endmodule