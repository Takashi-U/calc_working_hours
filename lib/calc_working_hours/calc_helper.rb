# -*- coding: utf-8 -*-

module CalcWorkingHours

  class CalcHelper
    class << self
      def valid_working_hours_format?(str)
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

      def valid_time_order?(first, second)
        false
        true if change_to_minute(first) <= change_to_minute(second)
      end

      def valid_range?(first, second)
        false
        true if change_to_minute(first) <= change_to_minute(second)
      end

      def valid_break_time?(break_time, starting_time, ending_time)
        flag = false
        break_time.each do |time|
          unless time
            return flag = true
          end
          if time.length == 2 && time.class == Array
            if valid_time_format?(time[0]) && valid_time_format?(time[1])
              time.each do |t|
                if change_to_minute(starting_time) > change_to_minute(t) || change_to_minute(ending_time) < change_to_minute(t)
                  return flag = false 
                end
              end
              flag = true
            end
          else
            return flag = false
          end
        end
        return flag
      end

      def total_break_time(break_time)
        total = WorkingHours.new("0:00")
        break_time.each do |time|
          unless time
            total.add_time(time[1]).minus_time(time[0])
          end
        end
        return total
      end
  
      def change_to_minute(str)
        /(\d+):(\d+)/ =~ str
        return $1.to_i * 60 + $2.to_i
      end
  
      def change_to_time_string(minute)
        hour = minute.div(60).to_s
        minute = (minute % 60).to_s
        if minute.length == 1
          minute = "0" + minute
        end
        return hour + ":" + minute
      end
    end

  end
end
