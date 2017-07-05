# -*- coding: utf-8 -*-

require "date"

module CalcWorkingHours

  class TimeCardRow
    attr_reader :starting_time, :ending_time, :break_time, :working_hours, :date_string, :time_point, :over_time, :id
    def initialize(date_string, starting_time, ending_time, auto_correction, *break_time)

      if auto_correction
        unless CalcHelper.valid_time_order?(starting_time, ending_time)
          et = WorkingHours.new(ending_time)
          ending_time = et.add_time("24:00").time_string
        end
      end

      unless date_string.class == String
        raise "failure set_date (date should string class)! TimeCardRow class"
      end

      unless CalcHelper.valid_time_format?(starting_time) && CalcHelper.valid_time_format?(ending_time)
        raise "failure initialize (invalid time format! TimeCardRow class)"
      end

      unless CalcHelper.valid_time_order?(starting_time, ending_time)
        raise "failure initialize (invalid time order! TimeCardRow class)"
      end

      unless break_time.empty?
        unless CalcHelper.valid_break_time?(break_time, starting_time, ending_time)
          raise "failure initialize (invalid break time! TimeCardRow class)"
        end
      end

      break_time.each do |time|
        unless CalcHelper.valid_time_order?(time[0], time[1])
          raise "failure initialize (invalid time order(break time)! TimeCardRow class)"
        end
      end

      total_break_time_string = "0:00"
      unless break_time.empty?
        total_break_time_string = CalcHelper.total_break_time(break_time).time_string
      end
      @date_string = date_string
      @starting_time = starting_time
      @ending_time = ending_time
      @break_time = break_time
      @working_hours = WorkingHours.new(ending_time).minus_time(starting_time).minus_time(total_break_time_string)
      @over_time = WorkingHours.new("0:00") if @over_time == nil
      @time_point = []
      @time_point << starting_time
      unless break_time.empty?
        break_time.each do |bt|
          @time_point << bt[0]
          @time_point << bt[1]
        end
      end
      @time_point << ending_time
      self
    end

    def set_fixed_working_hours(time)
      time = WorkingHours.new(time)
      working_hours = WorkingHours.new(@working_hours.time_string)
      if working_hours.minute < time.minute
        @over_time = working_hours.minus_time(working_hours.time_string)
      else
        @over_time = working_hours.minus_time(time.time_string)
      end
      self
    end

    def working_hours_in_range(start_range, end_range)
      i = @time_point.size / 2
      starting_time, ending_time = ""
      array_of_working_hours = []
      for counter in 1..i
        counter = 2 * counter - 2
        starting_time = @time_point[counter]
        ending_time = @time_point[counter + 1]

        if CalcHelper.valid_range?(end_range, starting_time) || CalcHelper.valid_range?(ending_time, start_range)
        elsif CalcHelper.valid_range?(start_range, starting_time) && CalcHelper.valid_range?(end_range, ending_time)
          array_of_working_hours << WorkingHours.new(end_range).minus_time(starting_time).time_string
        elsif CalcHelper.valid_range?(starting_time, start_range) && CalcHelper.valid_range?(end_range, ending_time)
          array_of_working_hours << WorkingHours.new(end_range).minus_time(start_range).time_string
        elsif CalcHelper.valid_range?(starting_time, start_range) && CalcHelper.valid_range?(ending_time, end_range)
          array_of_working_hours << WorkingHours.new(ending_time).minus_time(start_range).time_string
        elsif CalcHelper.valid_range?(start_range, starting_time) && CalcHelper.valid_range?(ending_time, end_range)
          array_of_working_hours << WorkingHours.new(ending_time).minus_time(starting_time).time_string
        end
      end
      return WorkingHours.new("0:00").add_array_time(array_of_working_hours).time_string
    end

    def between_10pm_and_5am
      self.working_hours_in_range("22:00", "29:00")
    end

  end
end
