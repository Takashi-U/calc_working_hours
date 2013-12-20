# -*- coding: utf-8 -*-

module CalcWorkingHours
  attr_reader :time_card_rows, :card_id, :id
  class TimeCard

    def initialize(card_id, id)
      @time_card_rows = []
      @card_id = card_id
      @id = id
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
      return WorkingHours.new("0:00").add_array_time(array_of_working_hours).time_string
    end

    def total_over_time
      array_of_over_time = []
      @time_card_rows.each do |row|
        array_of_over_time << row.over_time.time_string
      end
      return WorkingHours.new("0:00").add_array_time(array_of_over_time).time_string      
    end

    def total_working_hours_in_range(start_range, end_range)
      array_of_working_hours_in_range = []
      if start_range == true && end_range == true
        unless CalcHelper.valid_time_format?(start_range) || CalcHelper.valid_time_format?(end_range)
          raise "invalid time format (TimeCard total_working_hours)"
        end
      end
      @time_card_rows.each do |row|
        array_of_working_hours_in_range << row.working_hours_in_range(start_range, end_range)
      end
      return WorkingHours.new("0:00").add_array_time(array_of_working_hours_in_range).time_string
    end

  end
end
