module tt_um_bcd_counter (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        ena,
    input  wire [7:0]  ui_in,
    output wire [7:0]  uo_out,
    input  wire [7:0]  uio_in,
    output wire [7:0]  uio_out,
    output wire [7:0]  uio_oe
);

    reg [3:0] bcd_units;
    reg [3:0] bcd_tens;
    reg [3:0] bcd_hundreds;

    // No usamos bidireccionales
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // Salidas: decenas | unidades
    assign uo_out = {bcd_tens, bcd_units};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bcd_units    <= 4'd0;
            bcd_tens     <= 4'd0;
            bcd_hundreds <= 4'd0;
        end else if (ena) begin
            if (bcd_units == 4'd9) begin
                bcd_units <= 4'd0;
                if (bcd_tens == 4'd9) begin
                    bcd_tens <= 4'd0;
                    if (bcd_hundreds == 4'd9)
                        bcd_hundreds <= 4'd0;
                    else
                        bcd_hundreds <= bcd_hundreds + 1'b1;
                end else
                    bcd_tens <= bcd_tens + 1'b1;
            end else
                bcd_units <= bcd_units + 1'b1;
        end
    end

endmodule


