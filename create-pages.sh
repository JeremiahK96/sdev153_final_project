#!/bin/bash
#
# Jeremiah Knol
# 09/23/2023
#
# This is a script to handle very basic boilerplate for a website.
# Each document is structured from the boilerplate/document.html file.
#
# When run, any html documents in the pages/ directory will be created inside
# the website/ directory. The first line for a page file is the title, the
# second is the description, and the third is left blank. All remaining lines
# are inserted directly into the content section of the default document.html
# file.

boil_dir='boilerplate/'
page_dir='pages/'
site_dir='website/'
css_dir='css/'
root_dir='/home/betelgeuse/2023_fall/sdev153_web_site_development/sdev153_final_project/website'

title_placeholder="\*\*TITLE-GOES-HERE\*\*"
descr_placeholder="\*\*DESCRIPTION-GOES-HERE\*\*"
content_placeholder="\*\*PAGE-GOES-HERE\*\*"
root_placeholder="\*\*ROOT\*\*"

# Remove old website files.
rm -r "$site_dir"*

# Copy CSS directory into website.
cp -r "$css_dir" "$site_dir"

# Loop through all pages.
for page in $(find "$page_dir" -type f -name "*.html"); do

	# Get the title, description, and content for the page.
	title=$(head -1 "$page")
	descr=$(head -2 "$page" | tail -1)
	content=$(tail -n +4 "$page")

	# Get the file location to generate the new page to.
	newpage="${page#$page_dir}"
	newpage="$site_dir${newpage%^/*}"

	# Get the directory location for that new file. Make sure it exists.
	newdir="${newpage%/*}/"
	mkdir -p "$newdir"

	# Create the file, copy the default document.
	cp "${boil_dir}document.html" "$newpage"

	# Insert the new page's title and description.
	sed -i "s/$title_placeholder/$title/g" "$newpage"
	sed -i "s/$descr_placeholder/$descr/g" "$newpage"
	
	# Insert the new page's content.
	echo "$content" > tmp
	sed -i -e "/$content_placeholder/{r tmp" -e "d" -e "}" "$newpage"
	rm tmp

	# Insert the link prefix into all links.
	sed -i "s|$root_placeholder|$root_dir|g" "$newpage"

done
