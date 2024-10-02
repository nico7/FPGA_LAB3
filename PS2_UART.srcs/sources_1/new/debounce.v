//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2024 01:36:06 AM
// Design Name: 
// Module Name: debounce
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


module debounce(
    input clk,
    input button,
    output pushed
    );
    
    parameter WIDTH = 24;
    parameter THRESH = 24'hFFFFFE;
    
    reg button_pressed;
    reg [WIDTH - 1:0] clk_counter;
    reg [WIDTH - 1:0] button_counter;
    reg [WIDTH - 1:0] prev_button;
    
    assign pushed = button_pressed;
    always @(posedge clk) begin
        clk_counter <= clk_counter + 1;
    end 
    
    always @(posedge clk) begin
        if(clk_counter[17:0] == 18'h20000) begin
            button_counter <= {button_counter[WIDTH-2:0], button};
        end
    end
    
    always @(posedge clk) begin
        prev_button <= button_counter;
        
        if((button_counter == THRESH) && (prev_button != THRESH)) begin
            button_pressed <= 1'b1;
        end
        else begin
            button_pressed <= 1'b0;
        end
    end
endmodule
