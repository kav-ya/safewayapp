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
url = browser.window(:title, GROCERY_TITLE).url
browser.window(:title, GROCERY_URL).close
browser.goto url

browser.as(:href, AISLE_URL).first.click # Need to register and re-try

browser.text_field(:name, "Register.ZipCode").set ZIPCODE
browser.divs(:class, "btn btn-browseasguest").first.click
browser.as(:href, AISLE_URL).first.click

aisle_names = Array.new
aisle_links = browser.frames[NAVFRAME].as
aisle_links.each do |aisle|
    aisle_names.push(aisle.text)
    aisle.click # Watir waits

    product_list = Array.new
    subaisle_names = Array.new
    subaisle_links = browser.frames[NAVFRAME].as
    subaisle_links.each do |subaisle|
        subaisle_names.push(subaisle.text)
        subaisle.click
	
	shelf_names = Array.new
	shelf_links = browser.frames[NAVFRAME].as
	shelf_links.each do |shelf|
	    shelf_names.push(shelf.text)
	    shelf.click

	    # Populate product list:
	    titles = browser.frames[MAINFRAME].tds(:id, "producttitle")
	    prices = browser.frames[MAINFRAME].tds(:xpath, "//font[@id='price']")
	    
	    # TODO: ASSERT SAME SIZES
	    range = (0...titles.size).to_a
	    range.each do |i|
	        Product.new(titles[i].text, prices[i].text)

	end    
    

