# -*- coding: utf-8 -*-

module CalcWorkingHours

  class WorkingHours
    attr_reader :time_string, :minute
    def initialize(str)
      if valid_time_format?(str)
        @time_string = str
        self.to_minute
      else
        raise "failure initialize (invalid time format!)"
      end
    end

    def to_minute
      /(\d+):(\d+)/ =~ @time_string
      @minute = $1.to_i * 60 + $2.to_i
    end

    def add_time(str)
      if valid_time_format?(str)
        /(\d+):(\d+)/ =~ str
        minute_for_adding = $1.to_i * 60 + $2.to_i
        @minute = @minute + minute_for_adding
        hour = @minute.div(60)
        minute = @minute % 60
        @time_string = hour.to_s + ":" + minute.to_s
        self
      else
        raise "failure add_time (invalid time format!)"
      end
    end

    def valid_time_format?(str)
      flag = false
      if str.class == String
        if /\d+:(\d+)/ =~ str
          if $1.to_i < 60 && $1.to_i >= 0
            flag = true
          end
        end
      end
      return flag
    end
  end
end
