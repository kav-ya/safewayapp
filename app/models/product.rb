class Product < ActiveRecord::Base
    belongs_to :aisle
    attr_accessible :title, :price, :aisle_id
end
