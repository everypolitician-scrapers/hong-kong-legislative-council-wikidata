#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

names_5 = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://en.wikipedia.org/wiki/5th_Legislative_Council_of_Hong_Kong',
  after: '//span[@id="List_of_members"]',
  before: '//span[@id="Other_changes"]',
  xpath: './/tr[td]/td[4]//a[not(@class="new")]/@title',
)

names_6 = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://en.wikipedia.org/wiki/6th_Legislative_Council_of_Hong_Kong',
  after: '//span[@id="List_of_members"]',
  before: '//span[@id="Committees"]',
  xpath: '//table//tr[td]/td[4]//a[not(@class="new")]/@title',
)

sparq = <<~SPARQL
  SELECT DISTINCT ?item WHERE {
    ?item p:P39 [ ps:P39 wd:Q27908372 ; pq:P2937 ?term ] .
    ?term p:P31/pq:P1545 ?ordinal FILTER(xsd:integer(?ordinal) >= 5)
  }
SPARQL
ids = EveryPolitician::Wikidata.sparql(sparq)

EveryPolitician::Wikidata.scrape_wikidata(ids: ids, names: { en: names_5 | names_6 })
