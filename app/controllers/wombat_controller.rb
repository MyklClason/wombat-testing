class WombatController < ApplicationController

  def index
    results = scrape
    @tables = results["tables"]
    @images = results["images"]
  end

  private
  def scrape
    filter(scrape_ingrammicro())
  end
  def filter(results)
    tables = results["tables"]

    # Should filter if heading is nil
    tables.delete_if { |content| content["heading"].nil?}

    # Should filter if value or attribute is nil
    tables.each do |table|
      rows = table["rows"]
      rows.delete_if { | row | row["attr"].nil? || row["value"].nil? }
    end

    # Filter out any empty rows
    tables.delete_if { |content| content["rows"].empty?}
    results
  end

  def scrape_ingrammicro
    require 'wombat'
    Wombat.crawl do
      base_url "https://us-new.ingrammicro.com"
      #path "/_layouts/CommerceServer/IM/ProductDetails.aspx?id=US01@@9500@@10@@YW9103"
      path "/_layouts/CommerceServer/IM/ProductDetails.aspx?id=US01@@9500@@10@@YW8658"

      images xpath: "//img/@src", :iterator do
      end

      tables "css=table", :iterator do
        rows "css=tr"
        heading "css=th"
        rows "css=tr", :iterator do
          attr "css=td:nth-child(1)"
          value "css=td:nth-child(2)"
        end
      end
    end
  end
end
