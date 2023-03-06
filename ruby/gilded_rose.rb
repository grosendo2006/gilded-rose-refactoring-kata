class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      case item.name
      when "Aged Brie"
        AgedBrieItemDecorator.new(item).calculate
      when "Backstage passes to a TAFKAL80ETC concert"
        BackstageItemDecorator.new(item).calculate
      when "Sulfuras, Hand of Ragnaros"
        SulfurasItemDecorator.new(item).calculate
      else
        RegularItemDecorator.new(item).calculate
      end
    end
  end
end

require 'delegate'

class ItemDecorator < SimpleDelegator
  def update_sell_in
    self.sell_in = self.sell_in - 1
  end
end

class AgedBrieItemDecorator < ItemDecorator
  def calculate
    update_sell_in
    update_quality
  end

  def update_quality
    self.quality += 1
  end
end

class BackstageItemDecorator < ItemDecorator
  def calculate
    update_sell_in
    update_quality
  end

  def update_quality
    if self.sell_in < 0
      self.quality = 0
    # elsif self.sell_in .in?(6..10)
    elsif self.sell_in < 11 && self.sell_in > 5
      increase(2)
    # elsif self.sell_in.in?(1..5)
    elsif self.sell_in < 6 && self.sell_in > 0
      increase(3)
    else
      increase(1)
    end
  end

  def increase(quantity)
    if self.quality + quantity > 50
      self.quality = 50
    else
      self.quality = self.quality + quantity
    end
  end
end

class SulfurasItemDecorator < ItemDecorator
  def calculate; end
end

class RegularItemDecorator < ItemDecorator
  def calculate
    update_sell_in
    update_quality
  end

  def update_quality
    self.sell_in < 0 ? decrease(2) : decrease(1)
  end

  def decrease(quantity)
    if self.quality - quantity <= 0
      self.quality = 0
    else
      self.quality = self.quality - quantity
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
