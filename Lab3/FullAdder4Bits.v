include "FullAdder1Bit.v";
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