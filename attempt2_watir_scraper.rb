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

def main
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

    num_aisles = browser.frames[NAV_FRAME].as.size
    (0...num_aisles).to_a do |i|
    	browser.goto AISLE_URL
	scrape_aisle(i)
     end
end

def scrape_aisle(aislenum)
    browser.frames[NAV_FRAME].as[aislenum].click
    
    num_subaisles = browser.frames[NAV_FRAME].as.size
    (2...num_subaisles).to_a do |i| # 1 is self
    	scrape_subaisle(aislenum, i)
    end
end

def scrape_aisle(aislenum, subaislenum)
    browser.frames[NAV_FRAME].as[subaislenum].click
    scrape_shelf(aislenum, subaislenum, 3) # 2 is self
end

def scrape_shelf(aislenum, subaislenum, shelfnum)
    browser.frames[NAV_FRAME].as[shelfnum].click
    
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

	shelfs = browser.frames[NAV_FRAME].as.to_a
	shelf_grandparent_link = shelfs[0]
	shelf_parent_link = shelfs[1].href
	
	puts "SHELF_GRANDPARENT_LINK"
	puts shelf_grandparent_link.text
	puts shelf_grandparent_link.href

	puts "SHELF_PARENT_LINK"
	puts shelf_parent_link
#	puts shelf_parent_link.text
#	puts shelf_parent_link.href

	shelf_links = shelfs[3, shelfs.size] # 2 is self
	shelf_links.each do |shelf|
	    puts "SHELF"
	    puts shelf.text
	    shelf.click

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
	    
	    browser.goto shelf_parent_link

	end

	puts "BROWSER BACK?"

    end
end
end