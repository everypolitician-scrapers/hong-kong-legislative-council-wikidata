#!/bin/env ruby
# encoding: utf-8

require 'scraperwiki'
require 'wikidata/fetcher'
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'rest-client'

def noko_for(url)
  Nokogiri::HTML(open(url).read) 
end

def wikinames(url)
  noko = noko_for(url)
  noko.xpath('//h2[span[contains(.,"List of Members")]]/following-sibling::table[1]//tr[td]/td[4]//a[not(@class="new")]/@title').map(&:text)
end

names = wikinames('https://en.wikipedia.org/wiki/5th_Legislative_Council_of_Hong_Kong')
abort "No names" if names.count.zero?

WikiData.ids_from_pages('en', names).each_with_index do |p, i|
  data = WikiData::Fetcher.new(id: p.last).data rescue nil
  unless data
    warn "No data for #{p}"
    next
  end
  ScraperWiki.save_sqlite([:id], data)
end

warn RestClient.post ENV['MORPH_REBUILDER_URL'], {} if ENV['MORPH_REBUILDER_URL']
