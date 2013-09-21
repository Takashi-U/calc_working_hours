# -*- coding: utf-8 -*-

require "date"

module CalcWorkingHours

  class TimeCardRow
    attr_reader :starting_time, :ending_time, :break_time, :working_hours, :date_string
    def initialize(starting_time, ending_time, *break_time)
      unless valid_time_format?(starting_time) && valid_time_format?(ending_time)
        raise "failure initialize (invalid time format! TimeCardRow class)"
      end

      unless valid_time_order?(starting_time, ending_time)
        raise "failure initialize (invalid time order! TimeCardRow class)"
      end

      unless break_time.empty?
        unless valid_break_time?(break_time, starting_time, ending_time)
          raise "failure initialize (invalid break time! TimeCardRow class)"
        end
      end
      
      break_time.each do |time|
        unless valid_time_order?(time[0], time[1])
          raise "failure initialize (invalid time order(break time)! TimeCardRow class)"
        end
      end

      total_break_time_string = "0:00"
      unless break_time.empty?
        total_break_time_string = total_break_time(break_time)
      end

      @starting_time = starting_time
      @ending_time = ending_time
      @break_time = break_time
      @working_hours = WorkingHours.new(ending_time).minus_time(starting_time).minus_time(total_break_time_string)

      self
    end

    def set_date(date)
      unless date.class == String
        raise "failure set_date (date should string class)! TimeCardRow class"
      end
      @date_string = date
      self
    end

    private

    def total_break_time(break_time)
      total = WorkingHours.new("0:00")
      break_time.each do |time|
        total.add_time(time[1]).minus_time(time[0])
      end
      return total.time_string
    end

    def valid_time_card_row_format?(starting_time, ending_time)
      # break_timeについてはvalid_break_timeでチェック
      flag = false
      if valid_time_format?(starting_time) && valid_time_format?(ending_time)
        flag = true
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
      true if change_to_minute(first) < change_to_minute(second)
    end

    def valid_break_time?(break_time, starting_time, ending_time)
      flag = false
      break_time.each do |time|
        if time.length == 2 && time.class == Array
          if valid_time_format?(time[0]) && valid_time_format?(time[1])
            time.each do |t|
              if change_to_minute(starting_time) >= change_to_minute(t) || change_to_minute(ending_time) <= change_to_minute(t)
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

    def change_to_minute(str)
      /(\d+):(\d+)/ =~ str
      return $1.to_i * 60 + $2.to_i
    end

  end

end
