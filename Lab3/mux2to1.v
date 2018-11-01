module mux2to1(x, y, s, m);
    input x; 
    input y; 
    input s; 
    output m; 
    assign m = s & y | ~s & x;
endmodule