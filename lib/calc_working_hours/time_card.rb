# -*- coding: utf-8 -*-

module CalcWorkingHours
  attr_reader :time_card_rows, :card_id, :working_hours
  class TimeCard
    def initialize(card_id)
      @time_card_rows = []
      @card_id = card_id
      self
    end

    def add_row(time_card_rows_obj)
      @time_card_rows << time_card_rows_obj
      self
    end

    def total_working_hours
      array_of_working_hours = []
      @time_card_rows.each do |row|
        array_of_working_hours << row.working_hours.time_string
      end
      @working_hours = WorkingHours.new("0:00").add_array_time(array_of_working_hours).time_string
    end
  end
end
