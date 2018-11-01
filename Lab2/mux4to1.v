module mux4to1(u,v,w,x,s1,s0,m);
    input u,v,w,x;
    input s1,s0;
    output m;

    wire w1,w2;
    
    mux2to1 u1(u,v,s0,w1);
    mux2to1 u2(w,x,s0,w2);
    mux2to1 u0(w1,w2,s1,m);
        
endmodule