# -*- coding: utf-8 -*-
require "csv"

module CalcWorkingHours

  class TimeRecorder
    attr_reader :time_cards
    def initialize(path_to_csv, set_encode, card_id_row, starting_time_row, ending_time_row, date_row, *break_time_rows)

      csv_data = File.read(path_to_csv) if set_encode == nil || set_encode == false
      csv_data = File.read(path_to_csv, :encoding => set_encode + ":UTF-8") if set_encode
      time_cards = {}
      option_of_csv = {:headers => true, :return_headers => false}
      CSV.new(csv_data, option_of_csv).each do |row|
        header_row_flag = true
        row.each do |r|
          header_row_flag = false unless /[ぁ-ヶ]|[亜-黑]/ =~ r[1]
        end
        if header_row_flag
        elsif row[starting_time_row] != nil && row[ending_time_row] != nil
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
