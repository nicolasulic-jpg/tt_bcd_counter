import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def bcd_counter_test(dut):
    """Test del contador BCD de 0 a 9"""

    # Crear reloj de 100 MHz (10 ns)
    cocotb.fork(Clock(dut.clk, 10, units="ns").start())

    # Reset inicial
    dut.rst_n <= 0
    dut.ena <= 0
    await Timer(20, units="ns")

    dut.rst_n <= 1
    dut.ena <= 1

    # Comprobamos 20 ciclos de reloj
    for i in range(20):
        await RisingEdge(dut.clk)
        # Verificamos que el BCD se mantenga entre 0 y 9
        if int(dut.bcd_units.value) > 9:
            raise cocotb.result.TestFailure(
                f"BCD fuera de rango: {int(dut.bcd_units.value)} en ciclo {i}"
            )
        dut._log.info(f"Tiempo: {i*10} ns, BCD = {int(dut.bcd_units.value)}")
    
    # Fin del test
    dut.ena <= 0
    await Timer(10, units="ns")

