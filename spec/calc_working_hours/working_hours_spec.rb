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
  end

  context "7:70（7時間70分）が労働時間だった場合" do
    it '分の設定が60未満でないため、例外が発生すること' do
      proc { @working_hours = WorkingHours.new("7:70") }.should raise_error
    end
  end

end
