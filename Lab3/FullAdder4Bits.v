module fulladder4(InputA,InputB,Ci,Co,Output);
    input [3:0] InputA;
    input [3:0] InputB;   
    input Ci;
    input Co;
    output [3:0] Output;
    wire w1,w2,w3;

    fulladder1 a1(
        .Ci(Ci),
        .a(InputA[0]),
        .b(InputB[0]),
        .s(Output[0]),
        .Co(w1)
        );

    fulladder1 a2(
        .Ci(w1),
        .a(InputA[1]),
        .b(InputB[1]),
        .s(Output[1]),
        .Co(w2)
        );
    
    fulladder1 a3(
        .Ci(w2),
        .a(InputA[2]),
        .b(InputB[2]),
        .s(Output[2]),
        .Co(w3)
        );

    fulladder1 a4(
        .Ci(w3),
        .a(InputA[3]),
        .b(InputB[3]),
        .s(Output[3]),
        .Co(Co)
        );
endmodule

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

module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
    assign m = s & y | ~s & x;
endmodule

module xor_gate(y,a,b);
    input a,b;
    output y;
    assign y = (!a & b) | (a & !b);
endmodule