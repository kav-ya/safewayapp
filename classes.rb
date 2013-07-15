class Aisle < ActiveRecord::Base
      attr_accessor :aislenum, :name, :products

      def initialize(aislenum, name)
          @aislenum = aislenum
      	  @name = name
	  @products = Array.new
      end

      def add_product(product)
         @products.push(product)
      end
end

class Product < ActiveRecord::Base
      attr_accessor :aislenum, :name, :price

      def initialize(aislenum, name, price)
      	  @aislenum = aislenum
      	  @name = name
	  @price = price
      end
end