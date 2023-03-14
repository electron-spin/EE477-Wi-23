/**
* Conway's Game of Life Cell
*
* data_i[7:0] is status of 8 neighbor cells
* data_o is status this cell
* 1: alive, 0: death
*
* when en_i==1:
*   simulate the cell transition with 8 given neighors
* else when update_i==1:
*   update the cell status to update_val_i
* else:
*   cell status remains unchanged
**/

module bsg_cgol_cell (
    input clk_i   //synchronous clk

    ,input en_i            // compute enable 
    ,input [7:0] data_i    // 8 adjacent neighbor states

    ,input update_i     // enable to set state to update_val_i
    ,input update_val_i // value to set state to if update_i

    ,output logic data_o // cell’s current state
  );

  enum logic {dead, alive} state_n, state_r;

  logic [3:0] numOnes;

  // TODO: Design your bsg_cgl_cell
  // Hint: Find the module to count the number of neighbors from basejump
  bsg_popcount #(.width_p(8)) count (.i(data_i), .o(numOnes));

  always_comb begin
    if (en_i) begin
      state_n = state_r;
      if ( (state_r == alive) & (numOnes < 2) ) begin
        state_n = dead;
      end else if ( (state_r == alive) & ( (numOnes == 2) | (numOnes == 3) ) ) begin
        state_n = alive;
      end else if ( (state_r == alive) & (numOnes > 3) ) begin
        state_n = dead;
      end else if ( (state_r == dead) & (numOnes == 3) ) begin
        state_n = alive;
      end else begin
        state_n = dead;
      end
    end else if (update_i) begin
      state_n = update_val_i;
    end else begin
      state_n = state_r;
    end
  end

  always_ff @(posedge clk_i) begin
    state_r <= state_n;
  end

  assign data_o = state_r;
  
endmodule
