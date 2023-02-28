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

  enum {live, dead} state; 

  // TODO: Design your bsg_cgl_cell
  // Hint: Find the module to count the number of neighbors from basejump
  always_ff @(posedge clk_i) begin 
    if en_i == 1;
      if state = live and COUNT_ONES(data_i) < 2:
        state = dead;
      else if state = live and ( COUNT_ONES(data_i) == 2 or COUNT_ONES(data_i) == 3 ):
        state = live;
      else if state = live and COUNT_ONES(data_i) > 3:
        state = dead;
      else if state = dead and COUNT_ONESee(data_i) == 3:
        state = live;

  end
  
  assign data_o = (update_i) ? update_val_i : state;

    
    
  
  




endmodule
