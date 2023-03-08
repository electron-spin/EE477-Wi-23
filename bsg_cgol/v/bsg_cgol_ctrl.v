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
  logic overflowed_o;

  bsg_dff_en #(.width_p(game_len_width_lp)) dff (.clk_i, .data_i(frames_i), .en_i(ready_o & v_i), .data_o(frames_temp));

  bsg_counter_dynamic_limit_en #(.width_p(game_len_width_lp)) bsgC_U_D (.clk_i, .reset_i, .en_i(state_r == eBUSY), .limit_i(frames_temp), .counter_o, .overflowed_o);

  always_comb
    begin
      state_n = state_r;
      if (ready_o & v_i) begin
        state_n = eBUSY;
      end else if ((state_r == eBUSY) & overflowed_o) begin
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

  assign update_o = (state_r == eWAIT) & (state_n == eBUSY);
  assign en_o = (state_r == eBUSY) & (counter_o < frames_temp);

endmodule
