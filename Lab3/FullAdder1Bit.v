include"xor_gate.v";
include"mux2to1.v";
module fulladder1(Ci,a,b,s,Co);
    input Ci,a,b;
    output s,Co;
    wire w1;
    
    xor_gate x1(
        .y(w1),
        .a(a),
        .b(b)
        );

    xor_gate x2(
        .y(s),
        .a(Ci),
        .b(w1)
        );

    mux2to1 u1(
        .x(b),
        .y(Ci),
        .s(w1),
        .m(Co)
        );
endmodule