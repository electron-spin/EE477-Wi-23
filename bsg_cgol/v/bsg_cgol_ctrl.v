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

  wire unused;
  assign unused = en_i; // for clock gating, unused
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
  assign frames_temp = (state_r == eBUSY) ? frames_i : 'b1; 
  bsg_counter_dynamic_limit #(.width_p(game_len_width_lp)) bsgC_U_D (.clk_i, .reset_i, .limit_i(frames_temp), .counter_o);

  // bsg_counter_up_down #(.init_val_p(frames_i), .m) bsgC_U_D (.clk_i, .reset_i, .up_i('0), .down_i(1'b1), .count_o);

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


  

  always_comb
    begin
      state_n = state_r;
      update_n = update_r;
      en_n = en_r;
      if ((state_r == eWAIT) && v_i) begin
        state_n = eBUSY;
        update_n = 1'b1;
        en_n = 1'b1;
      end else if ((state_r == eBUSY) && (counter_o == frames_i)) begin
        state_n = eDONE;
        update_n = 1'b0;
        en_n = 1'b0;
      end else if ((state_r == eDONE) && yumi_i) begin
        state_n = eWAIT;
        update_n = 1'b0;
        en_n = 1'b0;
      end
    end

  always_ff @(posedge clk_i)
    begin
      if (reset_i) begin
          state_r <= eWAIT;
          en_r <= 1'b0;
          update_r <= 1'b0;
      end else begin
          state_r <= state_n;
          en_r <= en_n;
          update_r <= update_n;
      end
    end

  // assign update_n = (ready_o & v_i) ? 1'b1 : 
  //                   (state_r == eBUSY) ? 1'b0 : update_r;
  // assign en_n = (ready_o & v_i) ? 1'b0 : 
  //                   (state_r == eBUSY) ? 1'b1 : en_r;

  assign update_o = update_r;
  assign en_o = en_r;

endmodule



// module bsg_cgol_ctrl #(
//    parameter `BSG_INV_PARAM(max_game_length_p)
//   ,localparam game_len_width_lp=`BSG_SAFE_CLOG2(max_game_length_p)
// ) (
//    input clk_i,
//    input reset_i,

//   input en_i,

//   // Input Data Channel
//   input  [game_len_width_lp-1:0] frames_i,
//   input  v_i,
//   output ready_o,

//   // Output Data Channel
//   input yumi_i,
//   output v_o,

//   // Cell Array
//   output update_o,
//   output en_o);

//   wire unused = en_i; // for clock gating, unused
//   // wire test = frames_i;
//   // TODO: Design your control logic
//   logic [game_len_width_lp-1:0] counter_o;
//   logic update_n, update_r;
//   logic en_n, en_r;

//   bsg_counter_dynamic_limit #(.width_p(game_len_width_lp)) bsgC_U_D (.clk_i, .reset_i, .limit_i(frames_i), .counter_o);

//   // bsg_counter_up_down #(.init_val_p(frames_i), .m) bsgC_U_D (.clk_i, .reset_i, .up_i('0), .down_i(1'b1), .count_o);

//   typedef enum logic [1:0] {eWAIT, eBUSY, eDONE} state_e;

//   state_e  state_n, state_r;

//   assign ready_o = (state_r == eWAIT);
//   assign     v_o = (state_r == eDONE);

//   always_comb
//     begin
//       state_n = state_r;
//       if (ready_o & v_i) begin
//         state_n = eBUSY;
//       end else if ((state_r == eBUSY) & (counter_o == frames_i)) begin
//         state_n = eDONE;
//       end else if (v_o & yumi_i) begin
//         state_n = eWAIT;
//       end
//     end

//   always_ff @(posedge clk_i)
//     begin
//       if (reset_i)
//           state_r <= eWAIT;
//       else
//           state_r <= state_n;
//     end

//   assign update_n = (ready_o & v_i) ? 1'b1 : 
//                     (state_r == eBUSY) ? 1'b0 : update_r;
//   assign en_n = (ready_o & v_i) ? 1'b0 : 
//                     (state_r == eBUSY) ? 1'b1 : en_r;

//   always_ff @(posedge clk_i) begin
//     update_r <= update_n;
//     en_r <= en_n;
//   end

//   assign update_o = update_r;
//   assign en_o = en_r;

// endmodule