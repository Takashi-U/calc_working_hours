# -*- coding: utf-8 -*-
require "csv"

module CalcWorkingHours

  class TimeRecorder
    attr_reader :time_cards
    def initialize(path_to_csv, card_id_row, starting_time_row, ending_time_row, date_row, ignore_row_flag = 0, *break_time_rows)
      time_cards = {}
      option_of_csv = {:headers => true, :return_headers => false}
      CSV.foreach(path_to_csv, option_of_csv) do |row|
        if row[starting_time_row] != nil && row[ending_time_row] != nil && row[ignore_row_flag].to_i >= 1
          break_times = []
          unless break_time_rows.empty?
            break_time_rows.each do |bt|
              break_times << [row[bt[0]], row[bt[1]]] unless row[bt[0]] == nil || row[bt[1]] == nil
            end
          end

          if time_cards.has_key?(row[card_id_row])
            time_cards[row[card_id_row]].add_row(TimeCardRow.new(row[starting_time_row], row[ending_time_row], *break_times).set_date(row[date_row]))
          else
            time_cards[row[card_id_row]] = TimeCard.new(row[card_id_row])
            time_cards[row[card_id_row]].add_row(TimeCardRow.new(row[starting_time_row], row[ending_time_row], *break_times).set_date(row[date_row]))
          end
        end
      end
      @time_cards = time_cards
      self
    end
  end
end
