`define path \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[1]._clm_[1].rtr._nu_[0].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[1]._clm_[1].rtr._nu_[0].rtr_ntrfs_.data_out[31:0]].path[1][1] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[1]._clm_[1].rtr._nu_[1].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[1]._clm_[1].rtr._nu_[1].rtr_ntrfs_.data_out[31:0]].path[1][1] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[1]._clm_[1].rtr._nu_[2].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[1]._clm_[1].rtr._nu_[2].rtr_ntrfs_.data_out[31:0]].path[1][1] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[1]._clm_[1].rtr._nu_[3].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[1]._clm_[1].rtr._nu_[3].rtr_ntrfs_.data_out[31:0]].path[1][1] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[1]._clm_[2].rtr._nu_[0].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[1]._clm_[2].rtr._nu_[0].rtr_ntrfs_.data_out[31:0]].path[1][2] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[1]._clm_[2].rtr._nu_[1].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[1]._clm_[2].rtr._nu_[1].rtr_ntrfs_.data_out[31:0]].path[1][2] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[1]._clm_[2].rtr._nu_[2].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[1]._clm_[2].rtr._nu_[2].rtr_ntrfs_.data_out[31:0]].path[1][2] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[1]._clm_[2].rtr._nu_[3].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[1]._clm_[2].rtr._nu_[3].rtr_ntrfs_.data_out[31:0]].path[1][2] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[1]._clm_[3].rtr._nu_[0].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[1]._clm_[3].rtr._nu_[0].rtr_ntrfs_.data_out[31:0]].path[1][3] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[1]._clm_[3].rtr._nu_[1].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[1]._clm_[3].rtr._nu_[1].rtr_ntrfs_.data_out[31:0]].path[1][3] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[1]._clm_[3].rtr._nu_[2].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[1]._clm_[3].rtr._nu_[2].rtr_ntrfs_.data_out[31:0]].path[1][3] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[1]._clm_[3].rtr._nu_[3].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[1]._clm_[3].rtr._nu_[3].rtr_ntrfs_.data_out[31:0]].path[1][3] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[1]._clm_[4].rtr._nu_[0].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[1]._clm_[4].rtr._nu_[0].rtr_ntrfs_.data_out[31:0]].path[1][4] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[1]._clm_[4].rtr._nu_[1].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[1]._clm_[4].rtr._nu_[1].rtr_ntrfs_.data_out[31:0]].path[1][4] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[1]._clm_[4].rtr._nu_[2].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[1]._clm_[4].rtr._nu_[2].rtr_ntrfs_.data_out[31:0]].path[1][4] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[1]._clm_[4].rtr._nu_[3].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[1]._clm_[4].rtr._nu_[3].rtr_ntrfs_.data_out[31:0]].path[1][4] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[2]._clm_[1].rtr._nu_[0].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[2]._clm_[1].rtr._nu_[0].rtr_ntrfs_.data_out[31:0]].path[2][1] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[2]._clm_[1].rtr._nu_[1].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[2]._clm_[1].rtr._nu_[1].rtr_ntrfs_.data_out[31:0]].path[2][1] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[2]._clm_[1].rtr._nu_[2].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[2]._clm_[1].rtr._nu_[2].rtr_ntrfs_.data_out[31:0]].path[2][1] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[2]._clm_[1].rtr._nu_[3].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[2]._clm_[1].rtr._nu_[3].rtr_ntrfs_.data_out[31:0]].path[2][1] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[2]._clm_[2].rtr._nu_[0].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[2]._clm_[2].rtr._nu_[0].rtr_ntrfs_.data_out[31:0]].path[2][2] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[2]._clm_[2].rtr._nu_[1].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[2]._clm_[2].rtr._nu_[1].rtr_ntrfs_.data_out[31:0]].path[2][2] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[2]._clm_[2].rtr._nu_[2].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[2]._clm_[2].rtr._nu_[2].rtr_ntrfs_.data_out[31:0]].path[2][2] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[2]._clm_[2].rtr._nu_[3].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[2]._clm_[2].rtr._nu_[3].rtr_ntrfs_.data_out[31:0]].path[2][2] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[2]._clm_[3].rtr._nu_[0].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[2]._clm_[3].rtr._nu_[0].rtr_ntrfs_.data_out[31:0]].path[2][3] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[2]._clm_[3].rtr._nu_[1].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[2]._clm_[3].rtr._nu_[1].rtr_ntrfs_.data_out[31:0]].path[2][3] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[2]._clm_[3].rtr._nu_[2].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[2]._clm_[3].rtr._nu_[2].rtr_ntrfs_.data_out[31:0]].path[2][3] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[2]._clm_[3].rtr._nu_[3].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[2]._clm_[3].rtr._nu_[3].rtr_ntrfs_.data_out[31:0]].path[2][3] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[2]._clm_[4].rtr._nu_[0].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[2]._clm_[4].rtr._nu_[0].rtr_ntrfs_.data_out[31:0]].path[2][4] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[2]._clm_[4].rtr._nu_[1].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[2]._clm_[4].rtr._nu_[1].rtr_ntrfs_.data_out[31:0]].path[2][4] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[2]._clm_[4].rtr._nu_[2].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[2]._clm_[4].rtr._nu_[2].rtr_ntrfs_.data_out[31:0]].path[2][4] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[2]._clm_[4].rtr._nu_[3].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[2]._clm_[4].rtr._nu_[3].rtr_ntrfs_.data_out[31:0]].path[2][4] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[3]._clm_[1].rtr._nu_[0].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[3]._clm_[1].rtr._nu_[0].rtr_ntrfs_.data_out[31:0]].path[3][1] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[3]._clm_[1].rtr._nu_[1].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[3]._clm_[1].rtr._nu_[1].rtr_ntrfs_.data_out[31:0]].path[3][1] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[3]._clm_[1].rtr._nu_[2].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[3]._clm_[1].rtr._nu_[2].rtr_ntrfs_.data_out[31:0]].path[3][1] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[3]._clm_[1].rtr._nu_[3].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[3]._clm_[1].rtr._nu_[3].rtr_ntrfs_.data_out[31:0]].path[3][1] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[3]._clm_[2].rtr._nu_[0].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[3]._clm_[2].rtr._nu_[0].rtr_ntrfs_.data_out[31:0]].path[3][2] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[3]._clm_[2].rtr._nu_[1].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[3]._clm_[2].rtr._nu_[1].rtr_ntrfs_.data_out[31:0]].path[3][2] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[3]._clm_[2].rtr._nu_[2].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[3]._clm_[2].rtr._nu_[2].rtr_ntrfs_.data_out[31:0]].path[3][2] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[3]._clm_[2].rtr._nu_[3].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[3]._clm_[2].rtr._nu_[3].rtr_ntrfs_.data_out[31:0]].path[3][2] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[3]._clm_[3].rtr._nu_[0].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[3]._clm_[3].rtr._nu_[0].rtr_ntrfs_.data_out[31:0]].path[3][3] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[3]._clm_[3].rtr._nu_[1].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[3]._clm_[3].rtr._nu_[1].rtr_ntrfs_.data_out[31:0]].path[3][3] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[3]._clm_[3].rtr._nu_[2].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[3]._clm_[3].rtr._nu_[2].rtr_ntrfs_.data_out[31:0]].path[3][3] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[3]._clm_[3].rtr._nu_[3].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[3]._clm_[3].rtr._nu_[3].rtr_ntrfs_.data_out[31:0]].path[3][3] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[3]._clm_[4].rtr._nu_[0].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[3]._clm_[4].rtr._nu_[0].rtr_ntrfs_.data_out[31:0]].path[3][4] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[3]._clm_[4].rtr._nu_[1].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[3]._clm_[4].rtr._nu_[1].rtr_ntrfs_.data_out[31:0]].path[3][4] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[3]._clm_[4].rtr._nu_[2].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[3]._clm_[4].rtr._nu_[2].rtr_ntrfs_.data_out[31:0]].path[3][4] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[3]._clm_[4].rtr._nu_[3].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[3]._clm_[4].rtr._nu_[3].rtr_ntrfs_.data_out[31:0]].path[3][4] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[4]._clm_[1].rtr._nu_[0].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[4]._clm_[1].rtr._nu_[0].rtr_ntrfs_.data_out[31:0]].path[4][1] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[4]._clm_[1].rtr._nu_[1].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[4]._clm_[1].rtr._nu_[1].rtr_ntrfs_.data_out[31:0]].path[4][1] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[4]._clm_[1].rtr._nu_[2].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[4]._clm_[1].rtr._nu_[2].rtr_ntrfs_.data_out[31:0]].path[4][1] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[4]._clm_[1].rtr._nu_[3].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[4]._clm_[1].rtr._nu_[3].rtr_ntrfs_.data_out[31:0]].path[4][1] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[4]._clm_[2].rtr._nu_[0].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[4]._clm_[2].rtr._nu_[0].rtr_ntrfs_.data_out[31:0]].path[4][2] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[4]._clm_[2].rtr._nu_[1].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[4]._clm_[2].rtr._nu_[1].rtr_ntrfs_.data_out[31:0]].path[4][2] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[4]._clm_[2].rtr._nu_[2].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[4]._clm_[2].rtr._nu_[2].rtr_ntrfs_.data_out[31:0]].path[4][2] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[4]._clm_[2].rtr._nu_[3].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[4]._clm_[2].rtr._nu_[3].rtr_ntrfs_.data_out[31:0]].path[4][2] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[4]._clm_[3].rtr._nu_[0].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[4]._clm_[3].rtr._nu_[0].rtr_ntrfs_.data_out[31:0]].path[4][3] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[4]._clm_[3].rtr._nu_[1].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[4]._clm_[3].rtr._nu_[1].rtr_ntrfs_.data_out[31:0]].path[4][3] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[4]._clm_[3].rtr._nu_[2].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[4]._clm_[3].rtr._nu_[2].rtr_ntrfs_.data_out[31:0]].path[4][3] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[4]._clm_[3].rtr._nu_[3].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[4]._clm_[3].rtr._nu_[3].rtr_ntrfs_.data_out[31:0]].path[4][3] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[4]._clm_[4].rtr._nu_[0].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[4]._clm_[4].rtr._nu_[0].rtr_ntrfs_.data_out[31:0]].path[4][4] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[4]._clm_[4].rtr._nu_[1].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[4]._clm_[4].rtr._nu_[1].rtr_ntrfs_.data_out[31:0]].path[4][4] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[4]._clm_[4].rtr._nu_[2].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[4]._clm_[4].rtr._nu_[2].rtr_ntrfs_.data_out[31:0]].path[4][4] = 0; \
      end \
  end \
  begin \
      forever begin \
          @(posedge tb_top.dut_wr.DUT._rw_[4]._clm_[4].rtr._nu_[3].rtr_ntrfs_.pop); \
          score_arr2[tb_top.dut_wr.DUT._rw_[4]._clm_[4].rtr._nu_[3].rtr_ntrfs_.data_out[31:0]].path[4][4] = 0; \
      end \
  end 