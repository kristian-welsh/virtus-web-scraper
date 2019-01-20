class INS
	@@find_first = "FF"
	@@remove = "R"
	@@src_search = "SS"
	@@href_search = "HS"

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
		@funcs = {INS.find_first => :find_first_element,
			INS.remove => :remove_element,
			INS.src_search => :regex_src_search,
			INS.href_search => :regex_href_search}
		@g_ins = []
		@i_ins = []
	end

	def add_gallery_instruction ins, query
		@g_ins.push [ins,query]
	end

	def add_image_instruction ins, query
		@i_ins.push [ins,query]
	end

	# Transforms a gallery page into a list of urls.
	def image_urls resource
		opperate resource, @g_ins
	end

	# this assumes in the case of regex that there is only one match
	def get_image_uris image_page
		opperate image_page, @i_ins
	end

	def opperate webpage, instructions
		lines = seperate_lines webpage
		lines = perform_instructions instructions, lines
		lines.split("\n")
	end

	private

	# Seperates tags onto new lines in a HTML document
	def seperate_lines resource
		resource.gsub ">", ">\n"
	end

	def perform_instructions instructions, doc
		instructions.each do |ins|
			doc = self.send(@funcs[ins[0]], doc, ins[1])
		end
		doc
	end

	# Returns the first HTML element from some resource that matches a query
	# When an occurance of query is found on a line it returns that line
	# This assumes that each element is on its own line (see seperate_lines)
	def find_first_element resource, query
		seperated = ""
		tag_count = -1
		resource.each_line do |line|
			if line.include? query
				tag_count = 0
			end
			tag_count = update_tag_count(tag_count, line)
			if tag_count >= 0
				seperated << line
			end
		end
		seperated
	end

	# intended to be used by find_first_element
	def update_tag_count count, line
		if count >= 0
			if !line.include?("/>")
				if line.include?("<") && !line.include?("</")
					return count + 1
				end
				if line.include? "</"
					return count - 1
				end
			end
		end
		count
	end

	def remove_element resource, query
		new = ""
		resource.each_line do |line|
			if !line.include? query
				new << line
			end
		end
		new
	end

	def regex_src_search resource, query
		regex_attribute_search resource, "src", query
	end

	def regex_href_search resource, query
		regex_attribute_search resource, "href", query
	end

	def regex_attribute_search resource, attribute, query
		resource.scan(/(?<=#{attribute}=\")[^"]*#{query}[^"]*(?=\")/).join("\n")
	end
end

