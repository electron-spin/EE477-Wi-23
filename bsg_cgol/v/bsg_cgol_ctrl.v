module bsg_cgol_ctrl #(
   parameter `BSG_INV_PARAM(max_game_length_p)
  ,localparam game_len_width_lp=`BSG_SAFE_CLOG2(max_game_length_p)
) (
   input clk_i,
   input reset_i,

  input en_i,

  // Input Data Channel
  input  [game_len_width_lp-1:0] frames_i,
  input  v_i,
  output ready_o,

  // Output Data Channel
  input yumi_i,
  output v_o,

  // Cell Array
  output update_o,
  output en_o);

  wire unused = en_i; // for clock gating, unused
  // wire test = frames_i;
  // TODO: Design your control logic
  logic [game_len_width_lp-1:0] counter_o;
  logic update_n, update_r;
  logic en_n, en_r;

  typedef enum logic [1:0] {eWAIT, eBUSY, eDONE} state_e;

  state_e  state_n, state_r;

  assign ready_o = (state_r == eWAIT);
  assign     v_o = (state_r == eDONE);

  logic [game_len_width_lp-1:0] frames_temp;
  assign frames_temp = (ready_o & v_i) ? frames_i : frames_temp; 

  bsg_counter_dynamic_limit #(.width_p(game_len_width_lp)) bsgC_U_D (.clk_i, .reset_i, .limit_i(frames_temp), .counter_o);

  always_comb
    begin
      state_n = state_r;
      if (ready_o & v_i) begin
        state_n = eBUSY;
      end else if ((state_r == eBUSY) & (counter_o == frames_temp)) begin
        state_n = eDONE;
      end else if (v_o & yumi_i) begin
        state_n = eWAIT;
      end
    end

  always_ff @(posedge clk_i)
    begin
      if (reset_i)
          state_r <= eWAIT;
      else
          state_r <= state_n;
    end

  assign update_o = (ready_o & v_i) ? 1'b1 : 
                    (state_r == eBUSY) ? 1'b0 : 1'b0;
  assign en_o = (ready_o & v_i) ? 1'b0 : 
                    (state_r == eBUSY) ? 1'b1 : 1'b0;

  // always_ff @(posedge clk_i) begin
  //   update_r <= update_n;
  //   en_r <= en_n;
  // end

  // assign update_o = update_r;
  // assign en_o = en_r;

endmodule