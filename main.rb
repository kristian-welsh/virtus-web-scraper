require "../virtus web scraper/opperations.rb"

class INS
	@@find_first = FindFirstElement.new
	@@remove = RemoveElement.new
	@@src_search = SrcSearch.new
	@@href_search = HrefSearch.new

	def self.find_first
		@@find_first
	end

	def self.remove
		@@remove
	end

	def self.src_search
		@@src_search
	end

	def self.href_search
		@@href_search
	end
end

class GalleryDownloader
	def initialize()
		@ins = []
	end

	def add_instruction instruction, query
		@ins.push [instruction, query]
	end

	def opperate webpage
		lines = seperate_lines webpage
		lines = perform_instructions lines
		lines.split("\n")
	end

	private

	# Seperates tags onto new lines in a HTML document
	def seperate_lines resource
		resource.gsub ">", ">\n"
	end

	def perform_instructions doc
		@ins.each do |ins|
			doc = ins[0].send(:opperate, doc, ins[1])
		end
		doc
	end
end

