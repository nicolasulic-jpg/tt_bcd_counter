module tt_um_bcd_counter (
    input  wire clk,
    input  wire rst_n,
    input  wire enable,
    output reg [3:0] bcd_units,
    output reg [3:0] bcd_tens,
    output reg [3:0] bcd_hundreds
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bcd_units    <= 0;
            bcd_tens     <= 0;
            bcd_hundreds <= 0;
        end else if (enable) begin
            if (bcd_units == 9) begin
                bcd_units <= 0;
                if (bcd_tens == 9) begin
                    bcd_tens <= 0;
                    if (bcd_hundreds == 9)
                        bcd_hundreds <= 0;
                    else
                        bcd_hundreds <= bcd_hundreds + 1;
                end else
                    bcd_tens <= bcd_tens + 1;
            end else
                bcd_units <= bcd_units + 1;
        end
    end
endmodule
