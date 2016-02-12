class WombatController < ApplicationController

  # Todo:
  # Add a url model to store/parse urls (via uri)
  #   http://stackoverflow.com/a/8288172
  # Use the header to determine if page has changed
  #  Use previous version if it has not
  # Create a model to store the scrape results

  def index
    results = scrape
    @url = results["url"]
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

    url_base = "https://us-new.ingrammicro.com"
    url_path = "/_layouts/CommerceServer/IM/ProductDetails.aspx?id=US01@@9500@@10@@YW8658"
      #url_path =  "/_layouts/CommerceServer/IM/ProductDetails.aspx?id=US01@@9500@@10@@YW9103"

    Wombat.crawl do
      base_url url_base

      path url_path

      # Get the images for this (currently not working, try different approach)
      images xpath: "//img/@src"

      url url_base + url_path

      tables "css=table", :iterator do
        heading "css=th"
        rows "css=tr", :iterator do
          attr "css=td:nth-child(1)"
          value "css=td:nth-child(2)"
        end
      end
    end
  end
end
