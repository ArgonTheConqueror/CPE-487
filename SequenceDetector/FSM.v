//Objective: Use combinational logic towards a sequential application.
//Methods: Split the desired machine into a combinational logic section, and a sequential logic section. The sequential logic will be formed using flip-flops, while the combinational logic will be cases.


// D-flip flop implementation for this project
module dff ( 
    input Clock, D, Reset,
    output reg Q );
    
    always @(posedge Clock)
        begin
            if (Reset)
                Q = 1'b0;
            else
                Q = D;
        end
endmodule 

//Overall top-level structure of sequence detector
module seq_detect(
    input in,
    input clk, rst,
    output out );
    
    wire [2:0] CurrentState;
    wire [2:0] NextState;
    
    seq_logic (NextState, clk, rst, CurrentState);
    comb_logic (CurrentState, in, clk, rst, NextState, out);
    
endmodule

//Sequential logic composed of 3 D-flip flops to satisfy conditions for 8-bit memory
module seq_logic (
    input [2:0] NextState,
    input clk,
    input rst,
    output [2:0] CurrentState );
dff bit0 ( .Clock( clk ),
        .D( NextState[0]),
        .Reset( rst ),
        .Q( CurrentState[0]));
dff bit1 ( .Clock( clk ),
        .D( NextState[1]),
        .Reset( rst ),
        .Q( CurrentState[1]));
dff bit2 ( .Clock( clk ),
        .D( NextState[2]),
        .Reset( rst ),
        .Q( CurrentState[2]));
endmodule

//Combinatorial logic module to define Moore FSM
module comb_logic(
    input [2:0] y, // current state
    input in,
    input clk, rst,
    output [2:0] Y, // next state
    output reg out );
    
    reg [2:0] Y; // signals assigned in an always block must be registers
    always @ *
    case( {y, in} )
        4'b000_0: begin Y = 3'b000; out = 1'b0; end
        4'b000_1: begin Y = 3'b001; out = 1'b0; end
        4'b001_0: begin Y = 3'b010; out = 1'b0; end
        4'b001_1: begin Y = 3'b001; out = 1'b0; end
        4'b010_0: begin Y = 3'b011; out = 1'b0; end
        4'b010_1: begin Y = 3'b001; out = 1'b0; end 
        4'b011_0: begin Y = 3'b000; out = 1'b0; end
        4'b011_1: begin Y = 3'b100; out = 1'b0; end
        4'b100_0: begin Y = 3'b101; out = 1'b0; end
        4'b100_1: begin Y = 3'b001; out = 1'b0; end
        4'b101_0: begin Y = 3'b011; out = 1'b0; end
        4'b101_1: begin Y = 3'b110; out = 1'b0; end
        4'b110_0: begin Y = 3'b010; out = 1'b0; end
        4'b110_1: begin Y = 3'b111; out = 1'b0; end
        4'b111_0: begin Y = 3'b010; out = 1'b1; end
        4'b111_1: begin Y = 3'b001; out = 1'b0; end
        default: begin Y = 3'b000; out = 1'b0; end
    endcase
endmodule
