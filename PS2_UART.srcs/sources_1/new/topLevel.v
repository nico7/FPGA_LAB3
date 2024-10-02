`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2024 07:24:46 PM
// Design Name: 
// Module Name: topLevel
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


module topLevel(
input clk,
input btnC,
input PS2Clk,
input PS2Data,
output debug,
 output ca,
 output cb,
 output cc,
 output cd,
 output ce,
 output cf,
 output cg,
 output an_0,
 output an_1,
 output an_2,
 output anode
 );
 
 wire [3:0] count;
 wire rst;
 wire data_valid;
 
 debounce debounce_btn(
    .clk(clk),
    .button(btnC),
    .pushed(rst)
    );
    
    sev_seg number(
    .clk(clk),
    .rst(rst),
    .data_valid(data_valid),
    .count(count),
    .anode(anode),
    .ca(ca),
    .cb(cb),
    .cc(cc),
    .cd(cd),
    .ce(ce),
    .cf(cf),
    .cg(cg)
    );
    
    ps2 (
    .clk(clk),
    .rst(rst),
    .PS2Clk(PS2Clk),
    .PS2Data(PS2Data),
    .count(count),
    .data_valid(data_valid),
    .debug(debug)
    );
endmodule
