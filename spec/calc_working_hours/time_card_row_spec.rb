# -*- coding: utf-8 -*-
require 'spec_helper'

include CalcWorkingHours

describe TimeCardRow do
  context "始業9:00、終業19:00、休憩11:00〜12:00、15:00〜16:00のとき" do
    before do
      @time_card_row = TimeCardRow.new("2013/5/12", "9:00", "19:00", false, ["11:00", "12:00"], ["15:00", "16:00"])
    end

    it "始業時間は9:00となっている" do 
      @time_card_row.starting_time.should == "9:00"
    end

    it "終業時間は19:00となっている" do 
      @time_card_row.ending_time.should == "19:00"
    end

    it "労働時間は8:00となっている" do 
      @time_card_row.working_hours.time_string.should == "8:00"
    end

    it "time_pointは9:00,11:00,12:00,15:00,16:00,19:00" do 
      @time_card_row.time_point.should == ["9:00", "11:00", "12:00", "15:00", "16:00", "19:00"]
    end

    it "労働時間のうち、10:00〜15:30の間の労働時間は4:00" do 
      @time_card_row.working_hours_in_range("10:00", "15:30").should == "4:00"
    end

    it "労働時間のうち、11:30〜14:00の間の労働時間は2:00" do 
      @time_card_row.working_hours_in_range("11:00", "14:00").should == "2:00"
    end

    it "労働時間のうち、14:00〜17:00の間の労働時間は2:00" do 
      @time_card_row.working_hours_in_range("14:00", "17:00").should == "2:00"
    end

    it "所定労働時間を7:20とすると、残業時間は0:40となる" do 
      @time_card_row.set_fixed_working_hours("7:20").over_time.time_string.should == "0:40"
    end

    it "所定労働時間を8:20とすると、残業時間は0:00となる" do 
      @time_card_row.set_fixed_working_hours("8:20").over_time.time_string.should == "0:00"
    end
  end

  context "始業11:30、終業23:34、休憩15:38〜17:14のとき" do
    before do
      @time_card_row = TimeCardRow.new("2013/5/12", "11:30", "23:34", false, ["15:38", "17:14"])
    end

    it "所定労働時間を8:00とすると、残業時間は2:28となる" do 
      @time_card_row.set_fixed_working_hours("8:00").over_time.time_string.should == "2:28"
      puts @time_card_row.break_time
    end
  end

  context "始業9:00、終業18:00、休憩9:00〜18:00のとき" do
    before do
      @time_card_row = TimeCardRow.new("2013/5/12", "9:00", "18:00", false, ["9:00", "18:00"])
    end

    it "労働時間は0:00となる" do 
      @time_card_row.working_hours.time_string.should == "0:00"
    end
  end

  context "適正な時間設定と、不適な設定時間を設定したとき" do
    it "set_dateにString以外を設定すると例外が発生する" do
      proc { TimeCardRow.new(Date.new(2013, 5, 12), "22:00", "28:00", false) }.should raise_error
    end

    it "始業22:00、終業28:00は適正な始業・終業時間設定（0:00〜48:00）なので、エラーは発生しないこと" do
      proc{ TimeCardRow.new("2013/5/12", "22:00", "28:00", false) }.should_not raise_error
    end

    it "始業44:00、終業50:00は不適正な始業・終業時間設定なので、エラーが発生すること" do
      proc{ TimeCardRow.new("2013/5/12", "44:00", "50:00", false) }.should raise_error
    end

    it "始業四:00、終業5:00は不適正な時間フォーマットなので、エラーが発生すること" do
      proc{ TimeCardRow.new("2013/5/12", "四:00", "5:00" ,false)}.should raise_error
    end

    it "始業9:00、終業19:00の時系列に誤りが無いので、エラーは発生しないこと" do 
      proc { TimeCardRow.new("2013/5/12", "9:00", "19:00" ,false)}.should_not raise_error
    end

    it "始業18:00、終業8:00は時系列が誤っているので、エラーが発生すること" do
      proc { TimeCardRow.new("2013/5/12", "18:00", "9:00" ,false)}.should raise_error
    end

    it "始業8:00、終業19:00、休憩12:00〜11:00は時系列が誤っているので、エラーが発生すること" do
      proc { TimeCardRow.new("2013/5/12", "8:00", "19:00",false,["12:00", "10:00"]) }.should raise_error
    end

    it "始業8:00、終業19:00、休憩12:00は休憩時間設定が誤っているので、エラーが発生すること" do
      proc { TimeCardRow.new("2013/5/12", "8:00", "19:00", "12:00",false) }.should raise_error
    end

    it "始業8:00、終業19:00、休憩7:00〜11:00は時系列が誤っているので、エラーが発生すること" do
      proc { TimeCardRow.new("2013/5/12", "8:00", "19:00",false, ["7:00", "10:00"]) }.should raise_error
    end
  end

  context "始業20:00、終業25:00のとき" do
    it "深夜勤務時間は3:00となる" do
      TimeCardRow.new("2013/5/12", "20:00", "25:00", false).between_10pm_and_5am.should == "3:00"
    end
  end

  context "始業20:00、終業25:00、休憩23:00〜24:00のとき" do
    it "深夜勤務時間は4:00となる" do
      TimeCardRow.new("2013/5/12", "20:00", "25:00", false,["23:00", "24:00"]).between_10pm_and_5am.should == "2:00"
    end
  end

end
