# -*- coding: utf-8 -*-
require 'spec_helper'

include CalcWorkingHours

describe TimeCardRow do
  context "始業9:00、終業19:00、休憩11:00〜12:00、15:00〜16:00のとき" do
    before do
      @time_card_row = TimeCardRow.new("9:00", "19:00", ["11:00", "12:00"], ["15:00", "16:00"])
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

    it "set_dateにDateクラスのオブジェクトを渡すことで日付を設定できる" do
      @time_card_row.set_date("2013/8/1").date_string.class.should == String
    end

  end

  context "適正な時間設定と、不適な設定時間を設定したとき" do
    it "始業22:00、終業28:00は適正な始業・終業時間設定（0:00〜48:00）なので、エラーは発生しないこと" do
      proc{ TimeCardRow.new("22:00", "28:00") }.should_not raise_error
    end

    it "始業44:00、終業50:00は不適正な始業・終業時間設定なので、エラーが発生すること" do
      proc{ TimeCardRow.new("44:00", "50:00") }.should raise_error
    end

    it "始業四:00、終業5:00は不適正な時間フォーマットなので、エラーが発生すること" do
      proc{ TimeCardRow.new("四:00", "5:00") }.should raise_error
    end

    it "始業9:00、終業19:00の時系列に誤りが無いので、エラーは発生しないこと" do 
      proc { TimeCardRow.new("9:00", "19:00") }.should_not raise_error
    end

    it "始業18:00、終業8:00は時系列が誤っているので、エラーが発生すること" do
      proc { TimeCardRow.new("18:00", "9:00") }.should raise_error
    end

    it "始業8:00、終業19:00、休憩12:00〜11:00は時系列が誤っているので、エラーが発生すること" do
      proc { TimeCardRow.new("8:00", "19:00", ["12:00", "10:00"]) }.should raise_error
    end

    it "始業8:00、終業19:00、休憩12:00は休憩時間設定が誤っているので、エラーが発生すること" do
      proc { TimeCardRow.new("8:00", "19:00", "12:00") }.should raise_error
    end

    it "始業8:00、終業19:00、休憩7:00〜11:00は時系列が誤っているので、エラーが発生すること" do
      proc { TimeCardRow.new("8:00", "19:00", ["7:00", "10:00"]) }.should raise_error
    end

  end

end
