# -*- coding: utf-8 -*-
require 'spec_helper'

include CalcWorkingHours

describe TimeRecorder do
  context "data_sample.csv(Shift_JIS)の通りTimeRecorderが与えられている場合" do
    before do
      path_to_csv = File.expand_path(File.dirname(__FILE__)) + "/data_sample.csv"
      @time_recorder = TimeRecorder.new(path_to_csv, "Shift_JIS", "従業員番号", "カード番号", "年/月/日", "出勤打刻", "退勤打刻", false,["外出打刻", "戻打刻"])
    end

    it "タイムカードのデータが5件あること" do 
      @time_recorder.time_cards.size.should == 4
    end

    it "タイムカードのidが0000000001の人物の出勤日数は25日であること" do 
      @time_recorder.time_cards["0000000001"].time_card_rows.size.should == 25
    end

    it "タイムカードのidが0000000002の人物の5番目の出勤日は2013/07/27であること" do
      @time_recorder.time_cards["0000000002"].time_card_rows[4].date_string.should == "2013/07/27"
    end

    it "タイムカードのidが0000000084の人物の総労働時間は149:12であること" do 
      @time_recorder.time_cards["0000000084"].total_working_hours.should == "149:12"
    end

    it "タイムカードのidが0000000002の人物の11:00〜16:00の労働時間は87:02であること" do 
      @time_recorder.time_cards["0000000002"].total_working_hours_in_range("11:00", "16:00").should == "87:02"
    end

    it "タイムカードのidが0000000084の人物の従業員番号はであること" do 
      @time_recorder.time_cards["0000000084"].id.should == "00000004"
    end

  end

  context "invalid_data_sample.csv(Shift_JIS)の通りTimeRecorderが与えられている場合" do

    it "従業員番号が一致していない部分があるのでエラーが発生すること" do 
      path_to_csv = File.expand_path(File.dirname(__FILE__)) + "/invalid_data_sample.csv"
      proc{ TimeRecorder.new(path_to_csv, "Shift_JIS", "従業員番号", "カード番号", "出勤打刻", "退勤打刻", "年/月/日", ["外出打刻", "戻打刻"])}.should raise_error
    end

  end

end
