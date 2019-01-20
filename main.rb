class INS
	@@find_first = "FF"
	@@remove = "R"

	def self.find_first
		@@find_first
	end

	def self.remove
		@@remove
	end
end

class GalleryDownloader
	def initialize()
		@funcs = {INS.find_first => :find_first_element,
			INS.remove => :remove_element}
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
		new_doc = seperate_lines resource
		new_doc = perform_instructions @g_ins, new_doc
		new_doc.scan(/(?<=href=\")[^"]*(?=\")/)
	end

	# this assumes in the case of regex that there is only one match
	def get_image_uris image_page
		new_doc = seperate_lines image_page
		new_doc = perform_instructions @i_ins, new_doc
		new_doc.scan(/(?<=src=\")[^"]*#{@i_regex.source}[^"]*(?=\")/)
	end

	def set_image_regex regex
		@i_regex = regex
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
end

