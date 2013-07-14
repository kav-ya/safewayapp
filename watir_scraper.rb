#!/usr/bin/env ruby

require 'watir-webdriver'


# Urls:
SAFEWAY_URL = "www.safeway.com"
GROCERY_URL = "/ShopStores/Grocery-Delivery.page?"
GROCERY_TITLE = "Index: Home: Safeway Grocery Delivery"
AISLE_URL = "http://shop.safeway.com/superstore/default.asp?page=a"
# A California zipcode to fill in:
ZIPCODE = '94114'
# Frame numbers:
NAV_FRAME = 1
MAIN_FRAME = 2


browser = Watir::Browser.new :chrome

browser.goto SAFEWAY_URL # Watir waits

browser.as(:href, GROCERY_URL).first.click
browser.window(:title, GROCERY_TITLE).wait_until_present
url = browser.window(:title, GROCERY_TITLE).url
browser.window(:title, GROCERY_TITLE).close
browser.goto url

browser.as(:href, AISLE_URL).first.click # Need to register and re-try

browser.text_field(:name, "Register.ZipCode").set ZIPCODE
browser.divs(:class, "btn btn-browseasguest").first.click
browser.as(:href, AISLE_URL).first.click

aisle_links = browser.frames[NAV_FRAME].as
aisle_links.each do |aisle|
    puts "AISLE"
    puts aisle.text
    #db_aisle = Aisle.new(name:aisle.text)
    #db_aisle.save
    aisle.click # Watir waits

    subaisles = browser.frames[NAV_FRAME].as.to_a
    subaisle_parent_link = subaisles[0]
    subaisle_links = subaisles[2, subaisles.size] # 1 is self
    subaisle_links.each do |subaisle|
    	puts "SUBAISLE"
	puts subaisle.text
        subaisle.click

	#shelfs = browser.frames[NAV_FRAME].as.to_a
	shelfs = browser.frames[NAV_FRAME].as.collect { |link| link.href}
	#shelf_grandparent_link = shelfs[0]
	#shelf_parent_link = shelfs[1]
	#shelf_links = shelfs[3, shelfs.size] # 2 is self
	shelfs.each do |link|
	#shelf_links.each do |shelf|
	    puts "SHELF"
	    #puts shelf.text
	    browser.goto link
	    #shelf.click

	    # Populate product list:
	    titles = browser.frames[MAIN_FRAME].tds(:id, "producttitle")
	    prices = browser.frames[MAIN_FRAME].tds(:xpath, "//font[@id='price']")
	    
	    range = (0...titles.size).to_a
	    range.each do |i|
	    	puts "PRODUCT"
	    	puts titles[i].text
	        #db_product = Product.new(title:titles[i].text, price:prices[i].text)
		#db_product.aisle_id = aisle.id
		#db_product.save
	    end

	end

	puts "BROWSER BACK?"

    end
end
