#!/usr/bin/env ruby -w
# -*- coding: utf-8 -*-

# Check through the currently existing root_names of "wiki_pages.store" PStore data store
# and display only the wiki pages.

require "pstore"
require "./wiki_pages"

wiki = PStore.new("wiki_pages.store")
wiki.transaction do
	wiki.roots.each do |root_name|
		next if root_name == :wiki_index
		p root_name
		p wiki[root_name]
	end
end
