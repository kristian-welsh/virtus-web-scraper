# Opperatoins assume each element is on their own line
class Opperation
	def regex_attribute_search resource, attribute, query
		resource.scan(/(?<=#{attribute}=\")[^"]*#{query}[^"]*(?=\")/).join("\n")
	end

	def opperate resource, query
		resource
	end
end

class SrcSearch < Opperation
	def opperate resource, query
		regex_attribute_search resource, "src", query
	end
end

class HrefSearch < Opperation
	def opperate resource, query
		regex_attribute_search resource, "href", query
	end
end

class RemoveElement < Opperation
	def opperate resource, query
		new = ""
			resource.each_line do |line|
				if !line.include? query
					new << line
				end
			end
		new
	end
end


class FindFirstElement < Opperation
	def opperate resource, query
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

	private

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
end

