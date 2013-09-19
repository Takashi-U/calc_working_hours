# -*- coding: utf-8 -*-

module CalcWorkingHours

  class TimeCardRow
    attr_reader :starting_time, :ending_time, :break_time, :working_hours
    def initialize(starting_time, ending_time, break_time = [])
      if valid_time_format?(starting_time) && valid_time_format?(ending_time)
        self
      else
        raise "failure initialize (invalid time format! TimeCardRow class)"
      end
    end

    private
    def valid_time_card_row_format?(starting_time, ending_time, break_time)
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
    end

  end

end
