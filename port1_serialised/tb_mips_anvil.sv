`timescale 1ns / 1ps

module tb_mips_anvil();
    logic clk_i;
    logic rst_ni;

    // Instantiate the Anvil-generated Pipeline
    MipsPipeline uut (
        .clk_i(clk_i),
        .rst_ni(rst_ni)
    );

    // Generate a 10ns clock (100 MHz)
    always #5 clk_i = ~clk_i;

    initial begin
        // Initialize Inputs
        clk_i = 0;
        rst_ni = 0; // Assert reset (active low)

        // Wait 20 ns for global reset to finish
        #20;
        rst_ni = 1; // De-assert reset, start pipeline

        // Run simulation for 200ns to observe cycles
      #200;
        $finish;
    end
endmodule
