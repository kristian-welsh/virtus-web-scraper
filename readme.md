Virtus Web Scraper
==================

Currently limited in scope to downloading galleries of images.
Use add_gallery_instruction to add actions, which will be performed in order, to transform a web-page into a list of <a> tags. When you are done call image_urls with a web page as an argument, which will perform the work and if it was given proper instructions will return a list of urls to dedicated image pages.
add_image_instruction and get_image_uri work much the same way except with the purpose to transform the page into an image url. set_image_regex can be used to provide a regular expression that should specify part of the image url. if this regex is not set then the function will return all image urls present after instructions are applied

Instructions
------------

* Find First *
Returns the tag that first matches a query with that tag's contents

* Remove *
Returns only lines that match a provided query

