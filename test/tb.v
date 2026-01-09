`default_nettype none
`timescale 1ns/1ps

module testb;

    // Señales de prueba
    reg clk;
    reg rst_n;
    reg ena;
    wire [3:0] bcd_units;

    // Instanciamos el contador BCD
    tt_um_bcd_counter uut (
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .bcd_units(bcd_units)
    );

    // Generador de reloj: periodo 10 ns (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Toggle cada 5 ns
    end

    // Secuencia de prueba
    initial begin
        // Inicialización
        rst_n = 0;
        ena = 0;
        #20;           // Esperamos 20 ns

        rst_n = 1;     // Quitamos reset
        ena = 1;       // Habilitamos contador
        #200;          // Simulamos durante 200 ns

        ena = 0;       // Deshabilitamos contador
        #50;

        ena = 1;       // Volvemos a habilitar
        #100;

        $stop;         // Detenemos simulación
    end

    // Monitoreo de señales
    initial begin
        $display("Time\tclk\trst_n\tena\tbcd_units");
        $monitor("%0dns\t%b\t%b\t%b\t%0d", $time, clk, rst_n, ena, bcd_units);
    end

endmodule
