require 'nokogiri'

class ScrapeCovers::Parser
  def initialize(raw_html)
    @doc = Nokogiri::HTML(raw_html)
  end

  def parse

  end

  def results
    clean_results_rows.map do |result|

    end
  end

  # remove the header rows and BYE weeks
  def clean_result_rows
    results_rows.map do |result|
      next if is_header_row?(result) || is_bye_week?(result)
      result
    end.compact
  end

  def results_rows
    @doc.css('table.data tr')
  end

  def is_header_row?(row)
    !row.css('td.datahead').empty?
  end

  def is_bye_week?(row)
    row.css('td').first.content == "BYE"
  end
end
