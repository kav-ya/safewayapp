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

def generate_indexes

    # puts "GO TO AISLE URL"
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

    puts "NOW, GENERATE_INDEXES"

    num_aisles = browser.frames[NAV_FRAME].as.size

    puts "NUM_AISLES = ", num_aisles
    
    aisle_dict = Array.new(num_aisles)
    (0...num_aisles).to_a.each do |i|
        browser.goto AISLE_URL
	browser.frames[NAV_FRAME].as[i].click
	num_subaisles = browser.frames[NAV_FRAME].as.size
     	aisle_dict[i] = num_subaisles
     end

     puts "AISLE_DICT", aisle_dict

     subaisle_dict = Hash.new
     (0...num_aisles).to_a.each do |i|
     	 (2...aisle_dict[i]).to_a.each do |j|
             browser.goto AISLE_URL
	     browser.frames[NAV_FRAME].as[i].click
	     browser.frames[NAV_FRAME].as[j].click
	     num_shelfs = browser.frames[NAV_FRAME].as.size
	     subaisle_dict[[i, j]] = num_shelfs
	     puts "i,j = ", [i, j]
	     puts "NUM_SHELFS = ", num_shelfs
	 end
     end

     return num_aisles, subaisle_dict
end

a, b = generate_indexes
puts a
puts b