module bsg_cgol_ctrl #(
   parameter `BSG_INV_PARAM(max_game_length_p)
  ,localparam game_len_width_lp=`BSG_SAFE_CLOG2(max_game_length_p)
) (
   input clk_i
  ,input reset_i

  ,input en_i

  // Input Data Channel
  ,input  [game_len_width_lp-1:0] frames_i
  ,input  v_i
  ,output ready_o

  // Output Data Channel
  ,input yumi_i
  ,output v_o

  // Cell Array
  ,output update_o
  ,output en_o
);

  wire unused = en_i; // for clock gating, unused
  
  // TODO: Design your control logic

  typedef enum logic [1:0] {eWAIT, eBUSY, eDONE} state_e;

  state_e  state_n, state_r;

  logic [31:0] A_n, A_r; //n is now, r is ready
  logic [31:0] B_n, B_r; //n is now, r is ready


  always_ff @(posedge clk_i)
    begin
      if (reset_i)
          state_r <= eWAIT;
      else
          state_r <= state_n;
    end

    //logic for Euclidean algorithm:
    assign A_n = (ready_o & v_i) ? A_i :
          (state_r == eBUSY) & (A_r < B_r) ? B_r : (B_r != 0) ? A_r - B_r : A_r;

    assign B_n = (ready_o & v_i) ? B_i :
          (state_r == eBUSY) & (A_r < B_r) ? A_r : B_r;

  always_ff @(posedge clk_i)
    begin
      // output registers update on clock posedge 
      A_r <= A_n; 
      B_r <= B_n;
    end


  




endmodule
