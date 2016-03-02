#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

names = EveryPolitician::Wikidata.wikipedia_xpath( 
  url: 'https://en.wikipedia.org/wiki/5th_Legislative_Council_of_Hong_Kong',
  xpath: '//h2[span[contains(.,"List of Members")]]/following-sibling::table[1]//tr[td]/td[4]//a[not(@class="new")]/@title',
)
EveryPolitician::Wikidata.scrape_wikidata(names: { en: names })
