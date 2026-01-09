/*
 * Copyright (c) 2024
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_bcd_counter (
    input  wire [7:0] ui_in,    // Dedicated inputs (not used)
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path (not used)
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path
    input  wire       ena,      // Enable (from Tiny Tapeout)
    input  wire       clk,      // Clock
    input  wire       rst_n      // Active-low reset
);

    // -----------------------------
    // Internal BCD registers
    // -----------------------------
    reg [3:0] bcd_units;
    reg [3:0] bcd_tens;
    reg [3:0] bcd_hundreds;

    // -----------------------------
    // Output assignments
    // -----------------------------
    assign uo_out  = {bcd_tens, bcd_units};
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // -----------------------------
    // BCD counter logic
    // -----------------------------
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
            end else begin
                bcd_units <= bcd_units + 1'b1;
            end
        end
    end

    // -----------------------------
    // Unused inputs (avoid warnings)
    // -----------------------------
    wire _unused = &{ui_in, uio_in, 1'b0};

endmodule
