class WombatController < ApplicationController

  def index
    @results = scrape
  end

  private
  def scrape
    filter(scrape_ingrammicro())
  end
  def filter(results)
    tables = results["tables"]
    tables.delete_if { |content| content["heading"].nil?}
    tables
  end

  def scrape_ingrammicro
    require 'wombat'
    Wombat.crawl do
      base_url "https://us-new.ingrammicro.com"
      path "/_layouts/CommerceServer/IM/ProductDetails.aspx?id=US01@@9500@@10@@YW9103"

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
