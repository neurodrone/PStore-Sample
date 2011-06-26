#!/usr/bin/env ruby -w
# -*- coding: utf-8 -*-

# PStore (Ruby-based Key/Value Hash store) sample to store a wiki like structure

require "pstore"

class Wikipage
	def initialize(page_name, author, contents)
		@page_name = page_name
		@revisions = Array.new

		add_revision(author, contents)
	end

	attr_reader :page_name

	def add_revision(author, contents)
		@revisions << { :created => Time.now,
						:author => author,
						:contents => contents }
	end

	def wiki_page_references
		[@page_name] + @revisions.last[:contents].scan(/\b(?:[A-Z]+[a-z]+){2,}/)
	end
end

# Create a new page
 home_page = Wikipage.new("About Me", "Vaibhav Bhembre", "I wish I could write something here...")
 home_page.add_revision("Bhembre", "And there is nothing here either..")

# Update page data and index
wiki = PStore.new("wiki_pages.store")
wiki.transaction do
	wiki[home_page.page_name] = home_page
	wiki[:wiki_index] ||= Array.new

	wiki[:wiki_index].push(*home_page.wiki_page_references)
end 						# This commits data to the wiki_pages PStore

wiki.transaction do
	wiki.roots.each do |data_root_name|
#		if data_root_name == "About Me"
#			wiki.delete(data_root_name)
#			p "Deleted: " + data_root_name
#			next
#		end
		p data_root_name
		p wiki[data_root_name]
	end
end
