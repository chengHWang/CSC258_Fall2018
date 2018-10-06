module mux4to1(u,v,w,x,s1,s0,m);
    input u,v,w,x;
    input s1,s0;
    output m;

    wire w1,w2;
    
    mux2to1 u1(
        .x(u),
        .y(v),
        .s(s0),
        .m(w1)
        );
    
    mux2to1 u2(
        .x(w),
        .y(x),
        .s(s0),
        .m(w2)
        );

    mux2to1 u0(
        .x(w1),
        .y(w2),
        .s(s1),
        .m(m)
        );

endmodule