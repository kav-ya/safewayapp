#!/usr/bin/env ruby

require 'watir-webdriver'
require 'sequel'
require 'pg'

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

# Constants generated by indexes.rb:
NUM_AISLES = 20
AISLE_DICT = [6, 7, 5, 4, 7, 12, 7, 7, 7, 3, 9, 10, 5, 6, 10, 12, 19, 5, 3, 8]
SUBAISLE_DICT =
{[0, 2]=>8, [0, 3]=>8, [0, 4]=>13, [0, 5]=>13, [1, 2]=>12, [1, 3]=>13,
[1, 4]=>18, [1, 5]=>13, [1, 6]=>11, [2, 2]=>11, [2, 3]=>9, [2, 4]=>10,
[3, 2]=>8, [3, 3]=>8, [4, 2]=>12, [4, 3]=>11, [4, 4]=>10, [4, 5]=>23, [4, 6]=>10,
[5, 2]=>16, [5, 3]=>18, [5, 4]=>9, [5, 5]=>5, [5, 6]=>9, [5, 7]=>9, [5, 8]=>9,
[5, 9]=>13, [5, 10]=>8, [5, 11]=>11, [6, 2]=>15, [6, 3]=>12, [6, 4]=>9,
[6, 5]=>11, [6, 6]=>9, [7, 2]=>6, [7, 3]=>12, [7, 4]=>5, [7, 5]=>16, [7, 6]=>8,
[8, 2]=>4, [8, 3]=>23, [8, 4]=>13, [8, 5]=>7, [8, 6]=>9, [9, 2]=>4, [10, 2]=>8,
[10, 3]=>7, [10, 4]=>7, [10, 5]=>11, [10, 6]=>7, [10, 7]=>5, [10, 8]=>12,
[11, 2]=>13, [11, 3]=>4, [11, 4]=>32, [11, 5]=>5, [11, 6]=>6, [11, 7]=>5,
[11, 8]=>6, [11, 9]=>5, [12, 2]=>9, [12, 3]=>11, [12, 4]=>6, [13, 2]=>8,
[13, 3]=>11, [13, 4]=>4, [13, 5]=>10, [14, 2]=>10, [14, 3]=>7, [14, 4]=>8,
[14, 5]=>6, [14, 6]=>9, [14, 7]=>8, [14, 8]=>9, [14, 9]=>7, [15, 2]=>12,
[15, 3]=>16, [15, 4]=>8, [15, 5]=>7, [15, 6]=>9, [15, 7]=>8, [15, 8]=>12,
[15, 9]=>7, [15, 10]=>11, [15, 11]=>13, [16, 2]=>16, [16, 3]=>13, [16, 4]=>8,
[16, 5]=>7, [16, 6]=>5, [16, 7]=>8, [16, 8]=>6, [16, 9]=>7, [16, 10]=>11,
[16, 11]=>4, [16, 12]=>8, [16, 13]=>16, [16, 14]=>12, [16, 15]=>6, [16, 16]=>13,
[16, 17]=>21, [16, 18]=>19, [17, 2]=>8, [17, 3]=>7, [17, 4]=>4, [18, 2]=>5,
[19, 2]=>10, [19, 3]=>5, [19,4]=>18, [19, 5]=>9, [19, 6]=>12, [19, 7]=>13}

# Connect to DB, get tables
DB = Sequel.connect(:adapter=>'postgres', :host=>'localhost',
                        :database=>'safewayapp_development', :user=>'kavya',
								:password=>'')
AISLES_TABLE = DB[:aisles]
PRODUCTS_TABLE = DB[:products]

def main
    browser = Watir::Browser.new :chrome
#    browser.goto SAFEWAY_URL # Watir waits

#    browser.as(:href, GROCERY_URL).first.click
#    browser.window(:title, GROCERY_TITLE).wait_until_present
#    url = browser.window(:title, GROCERY_TITLE).url
#    browser.window(:title, GROCERY_TITLE).close
#    browser.goto url

#    browser.as(:href, AISLE_URL).first.click # Need to register and re-try
     
     browser.goto AISLE_URL # REMOVE THIS!
     Watir::Wait.until{ 120 }


    browser.text_field(:name, "Register.ZipCode").set ZIPCODE
    browser.divs(:class, "btn btn-browseasguest").first.click
#    browser.as(:href, AISLE_URL).first.click

     browser.goto AISLE_URL # REMOVE THIS!
     Watir::Wait.until { 120 }

     # MAKE 0!
     #i_array = (1...NUM_AISLES).to_a
     #i_array.each do |i|
        #aid = AISLES_TABLE.insert(:name=>browser.frames[NAV_FRAME].as[i].text)
	#puts "AID = ", aid	

	i = 1
	aid = 3

	# 2, 3
	j_array = (5...AISLE_DICT[i]).to_a
	#j_array = [4]
	j_array.each do |j|
	    k_array = (3...SUBAISLE_DICT[[i, j]]).to_a
	    k_array.each do |k|
	        browser.goto AISLE_URL
		Watir::Wait.until{ 120 }

		browser.frames[NAV_FRAME].as[i].click

             	Watir::Wait.until { browser.frames[NAV_FRAME].as.size ==
				    AISLE_DICT[i] }
             	browser.frames[NAV_FRAME].as[j].click
	
		Watir::Wait.until{ 120 }

		Watir::Wait.until { browser.frames[NAV_FRAME].as.size ==
                                    SUBAISLE_DICT[[i, j]] }
		browser.frames[NAV_FRAME].as[k].click
		    
		puts "i, j, k = ", i, j, k

		Watir::Wait.until{ 120 }

    		titles = browser.frames[MAIN_FRAME].tds(:id, "producttitle")
    		prices = browser.frames[MAIN_FRAME].tds(:xpath,
							"//font[@id='price']")

		scrape_shelf(aid, titles, prices)
	    end
        end 
    #end
end

def scrape_shelf(aislenum, titles, prices)
    (0...titles.size).to_a.each do |i|
	puts "PRODUCT"
	PRODUCTS_TABLE.insert(:title=>titles[i].text, :price=>prices[i].text,
			      :aisle_id=>aislenum)
	
        puts titles[i].text, prices[i].text
    end
end

# Call main:
main