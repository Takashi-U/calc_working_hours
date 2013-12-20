# -*- coding: utf-8 -*-
require 'spec_helper'

include CalcWorkingHours

describe TimeCard do
  context "始業9:00、終業19:00、休憩11:00〜12:00、15:00〜16:00が2日間のとき" do
    before do
      @time_card = TimeCard.new(1,1)
      @time_card.add_row(TimeCardRow.new("2013/5/12", "9:00", "19:00", ["11:00", "12:00"], ["15:00", "16:00"]).set_fixed_working_hours("7:00"))
      @time_card.add_row(TimeCardRow.new("2013/5/13", "9:00", "19:00", ["11:00", "12:00"], ["15:00", "16:00"]).set_fixed_working_hours("7:00"))
    end

    it "残業時間のトータルは2:00となる" do
      @time_card.total_over_time.should == "2:00"
    end

  end
end
