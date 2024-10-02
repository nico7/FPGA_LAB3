

module ps2 (
input clk,
input rst,
input PS2Clk,
input PS2Data,
output [3:0] count,
output data_valid,
output debug
);

parameter IDLE = 2'h0;
parameter RECEIVING = 2'h1;
parameter ERROR = 2'h2;

parameter ZERO      = 8'h45;
parameter ONE       = 8'h16;
parameter TWO       = 8'h1E;
parameter THREE     = 8'h26;
parameter FOUR      = 8'h25;
parameter FIVE      = 8'h2E;
parameter SIX       = 8'h36;
parameter SEVEN     = 8'h3D;
parameter EIGHT     = 8'h3E;
parameter NINE      = 8'h46;

reg [3:0] bit_count;
reg [3:0] count_buffer;
reg prev_clk, pres_clk, clk_neg_edge;
reg prev_data, pres_data;
reg [1:0] state;
reg [7:0] data_byte;
reg byte_valid;
reg parity, parity_calc;

reg debug_out;

assign data_valid = byte_valid;
assign count = count_buffer;
assign debug = debug_out;

always @(posedge clk) begin
    debug_out <= PS2Data;
end 
always @(posedge clk) begin
    if (rst == 1'b1) begin
        prev_clk <= 1'b0;
        pres_clk <= 1'b0;
        clk_neg_edge <= 1'b0;
    end
    else begin
        prev_clk <= pres_clk;
        pres_clk <= PS2Clk;
        
        clk_neg_edge <= prev_clk & ~pres_clk;
    end
end

always @(posedge clk) begin
    if(rst == 1'b1) begin
        state <= IDLE;
        bit_count <= 4'h1;
        data_byte <= 8'h00;
        byte_valid <= 1'b1;
        parity <= 1'b0;
        parity_calc <= 1'b0;
        count_buffer <= 4'h0;
    end
    else begin
        case(state)
            IDLE: begin
                if(PS2Data == 1'b0 && clk_neg_edge == 1'b1) begin
                    state <= RECEIVING;
                    byte_valid <= 1'b0;
                end
                
                case(data_byte)
                    ZERO: begin
                        count_buffer <= 4'h0;
                    end
                    ONE: begin
                        count_buffer <= 4'h1;
                    end
                    TWO: begin
                        count_buffer <= 4'h2;
                    end
                    THREE: begin
                        count_buffer <= 4'h3;
                    end
                    FOUR: begin
                        count_buffer <= 4'h4;
                    end
                    FIVE: begin
                        count_buffer <= 4'h5;
                    end
                    SIX: begin
                        count_buffer <= 4'h6;
                    end
                    SEVEN: begin
                        count_buffer <= 4'h7;
                    end
                    EIGHT: begin
                        count_buffer <= 4'h8;
                    end
                    NINE: begin
                        count_buffer <= 4'h9;
                    end
                    default: begin
                        count_buffer <= 4'h0;
                    end
                endcase
                
                
            end
            RECEIVING:begin
                if(clk_neg_edge == 1'b1) begin
                    if(bit_count == 4'hA) begin
                        state <= IDLE;
                        bit_count <= 4'h1;
                        if(parity == parity_calc) begin
                            byte_valid <= 1'b1;
                        end
                        else begin
                            byte_valid <= 1'b0;
                        end
                    end
                    else begin
                        bit_count <= bit_count + 1;
                        if(bit_count < 4'h9) begin
                            data_byte[8 - bit_count] <= PS2Data;
                        end
                        else if(bit_count == 9) begin
                            parity <= PS2Data;
                            parity_calc <= ^bit_count;
                        end
                    end
                end
            end
            default:
                state <= IDLE;
        endcase
    end
end

endmodule