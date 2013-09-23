# -*- coding: utf-8 -*-

module CalcWorkingHours

  class WorkingHours
    attr_reader :time_string, :minute
    def initialize(str)
      if CalcHelper.valid_working_hours_format?(str)
        @time_string = str
        self.to_minute
        self
      else
        raise "failure initialize (invalid time format!)"
      end
    end

    def to_minute
      @minute = CalcHelper.change_to_minute(@time_string)
    end

    def add_time(str)
      if CalcHelper.valid_working_hours_format?(str)
        @minute = @minute + CalcHelper.change_to_minute(str)
        @time_string = CalcHelper.change_to_time_string(@minute)
        self
      else
        raise "failure add_time (invalid time format!)"
      end
    end

    def add_array_time(array)
      array.each do |str|
        self.add_time(str)
      end
      self
    end

    def minus_time(str)
      if CalcHelper.valid_working_hours_format?(str)
        minute = @minute - CalcHelper.change_to_minute(str)
        if minute >= 0
          @minute = minute
          @time_string = CalcHelper.change_to_time_string(@minute)
          self
        else 
          raise "failure add_time (invalid time format!)"
        end
      end
    end

  end
end
