# -*- coding: utf-8 -*-

module CalcWorkingHours
  attr_reader :time_card_rows, :card_id, :working_hours, :id
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
      @working_hours = WorkingHours.new("0:00").add_array_time(array_of_working_hours).time_string
    end

    def total_working_hours_in_range(start_range, end_range)
      array_of_working_hours_in_range = []
      if start_range == true && end_range == true
        unless valid_time_format?(start_range) || valid_time_format?(end_range)
          raise "invalid time format (TimeCard total_working_hours)"
        end
      end
      @time_card_rows.each do |row|
        array_of_working_hours_in_range << row.working_hours_in_range(start_range, end_range)
      end
      return WorkingHours.new("0:00").add_array_time(array_of_working_hours_in_range).time_string
    end

    private

    def valid_range?(first, second)
      false
      true if change_to_minute(first) < change_to_minute(second)
    end

    def valid_time_format?(time)
      flag = false
      if time.class == String
        if /(\d+):(\d+)/ =~ time
          if ($1.to_i <= 48 && $1.to_i >= 0) && ($2.to_i < 60 && $2.to_i >= 0)
            flag = true
          end
        end
      end
      return flag
    end

    def change_to_minute(str)
      /(\d+):(\d+)/ =~ str
      return $1.to_i * 60 + $2.to_i
    end

  end
end
