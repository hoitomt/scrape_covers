require 'nokogiri'

module ScrapeCovers
  class Parser
    def initialize(team, raw_html)
      @team = team
      @doc = Nokogiri::HTML(raw_html)
    end

    def parse
      clean_result_rows.map do |result|
        Result.new(@team, result).save!
      end
    end

    # remove the header rows and BYE weeks
    def clean_result_rows
      raise "Missing data" if result_rows.empty?
      result_rows.map do |result|
        next if is_header_row?(result) || is_bye_week?(result)
        result
      end.compact
    end

    def result_rows
      @doc.css('table.data tr')
    end

    def is_header_row?(row)
      !row.css('td.datahead').empty?
    end

    def is_bye_week?(row)
      row.css('td').first.content == "BYE"
    end
  end
end
