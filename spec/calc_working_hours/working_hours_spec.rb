# -*- coding: utf-8 -*-
require 'spec_helper'

include CalcWorkingHours

describe WorkingHours do
  context "7:45（7時間45分）が労働時間だった場合" do
    before do
      @working_hours = WorkingHours.new("7:45")
    end
  
    it "7:45を分数にすると465分であること" do
      @working_hours.minute.should == 465
    end

    it "2:25を加えると、10:10になること" do
      @working_hours.add_time("2:25")
      @working_hours.time_string.should == "10:10"
    end

    it "2:75を加えると、分の設定が60未満でないため、例外が発生すること" do
      proc { @working_hours.add_time("2:75") }.should raise_error
    end

    it "2:25を加え、さらに3:00を加えると13:10になること（add_timeはチェインできること）" do
      @working_hours.add_time("2:25").add_time("3:00").time_string.should == "13:10"
    end

    it "1:50を引くと、5:55になること" do
      @working_hours.minus_time("1:50").time_string.should == "5:55"
    end

    it "7:45を引くと、0:00になること" do 
      @working_hours.minus_time("7:45").time_string.should == "0:00"
    end

    it "8:50を引くと、マイナスになるため、例外が発生すること" do
      proc{ @working_hours.minus_time("8:50").time_string }.should raise_error
    end

    it "2:25を引き、さらに3:00を引くと2:20になること（minus_timeはチェインできること）" do
      @working_hours.minus_time("2:25").minus_time("3:00").time_string.should == "2:20"
    end

    it '["1:10", "2:20", "3:30", "4:40"]を足すと、19:35になること（add_array_timeは配列を渡すと合計する）' do
      @working_hours.add_array_time(["1:10", "2:20", "3:30", "4:40"]).time_string.should == "19:25"
    end
      

  end

  context "7:70（7時間70分）が労働時間だった場合" do
    it '分の設定が60未満でないため、例外が発生すること' do
      proc { @working_hours = WorkingHours.new("7:70") }.should raise_error
    end
  end

end
