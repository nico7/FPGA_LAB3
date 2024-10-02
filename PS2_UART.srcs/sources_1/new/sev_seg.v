//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2024 02:20:53 AM
// Design Name: 
// Module Name: sev_seg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sev_seg(
    input clk,
    input rst,
    input [3:0] count,
    input data_valid,
    output anode,
    output ca,
    output cb,
    output cc,
    output cd,
    output ce,
    output cf,
    output cg
    );
    
    parameter ZERO  = 4'h0;
    parameter ONE   = 4'h1;
    parameter TWO   = 4'h2;
    parameter THREE = 4'h3;
    parameter FOUR  = 4'h4;
    parameter FIVE  = 4'h5;
    parameter SIX   = 4'h6;
    parameter SEVEN = 4'h7;
    parameter EIGHT = 4'h8;
    parameter NINE  = 4'h9;
    
    
    reg an_out;
    reg [6:0] cathodes;
    reg [17:0] clk_counter;
    
    assign anode = an_out;
    assign {ca, cb, cc, cd, ce, cf, cg} = cathodes; 
    
    always @(posedge clk) begin
        if(rst == 1'b1) begin
            clk_counter <= 0;
        end
        else begin
            clk_counter <= clk_counter + 1;
        end
    end
    
    always @(posedge clk) begin
        if(rst == 1'b1) begin
            an_out <= 1'b1;
        end
        else if (clk_counter[17]== 1) begin
            an_out <= ~an_out;
        end
    end
    
    always @(posedge clk) begin
        if(rst == 1'b1) begin
            cathodes <= 8'hFF;
        end
        else begin
            if(data_valid == 1'b1) begin
                case(count)
                    ZERO:
                        cathodes <= ~7'h7E;
                    ONE:
                        cathodes <= ~7'h30;
                    TWO:
                        cathodes <= ~7'h6D;    
                    THREE:
                        cathodes <= ~7'h79;
                    FOUR:
                        cathodes <= ~7'h33;
                    FIVE:
                        cathodes <= ~7'h5B;              
                    SIX:
                        cathodes <= ~7'h5F;
                    SEVEN:
                        cathodes <= ~7'h71;
                    EIGHT:
                        cathodes <= ~7'h7F;                
                    NINE:
                        cathodes <= ~7'h73;
                    default:
                        cathodes <= ~7'h01;
                endcase
            end
        end
    end
    
endmodule
