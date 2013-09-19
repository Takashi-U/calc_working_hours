# -*- coding: utf-8 -*-

module CalcWorkingHours

  class WorkingHours
    attr_reader :time_string, :minute
    def initialize(str)
      if valid_time_format?(str)
        @time_string = str
        self.to_minute
        self
      else
        raise "failure initialize (invalid time format!)"
      end
    end

    def to_minute
      @minute = change_to_minute(@time_string)
    end

    def add_time(str)
      if valid_time_format?(str)
        @minute = @minute + change_to_minute(str)
        @time_string = change_to_time_string(@minute)
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
      if valid_time_format?(str)
        minute = @minute - change_to_minute(str)
        if minute >= 0
          @minute = minute
          @time_string = change_to_time_string(@minute)
          self
        else 
          raise "failure add_time (invalid time format!)"
        end
      end
    end

    private
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

    def change_to_minute(str)
      /(\d+):(\d+)/ =~ str
      return $1.to_i * 60 + $2.to_i
    end

    def change_to_time_string(minute)
      hour = minute.div(60)
      minute = minute % 60
      return hour.to_s + ":" + minute.to_s
    end

  end
end
