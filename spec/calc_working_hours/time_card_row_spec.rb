# -*- coding: utf-8 -*-
require 'spec_helper'

include CalcWorkingHours

describe TimeCardRow do
  context "始業9:00、終業19:00、休憩11:00〜12:00、15:00〜16:00のとき" do
    before do
      @time_card_row = TimeCardRow.new("9:00", "19:00", [["11:00", "12:00"], ["15:00", "16:00"]])
#      puts "hogefuga"
    end
  end

  context "適正な時間設定と、不適な設定時間を設定する" do
    it do "始業22:00、終業28:00は適正な始業・終業時間設定（0:00〜48:00）である"
      proc{ TimeCardRow.new("22:00", "28:00") }.should_not raise_error
    end

    it do "始業44:00、終業50:00は不適正な始業・終業時間設定である"
      proc{ TimeCardRow.new("44:00", "50:00") }.should raise_error
    end
  end

end
