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
      when "Conjured"
        ConjuredItemDecorator.new(item).calculate
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

  def decrease_quality_by(amount)
    quality_going_bellow_zero?(amount) ? self.quality = 0 : decrease_quality(amount)
  end

  private

  def quality_going_bellow_zero?(amount)
    self.quality - amount <= 0
  end

  def decrease_quality(amount)
    self.quality = self.quality - amount
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
    elsif self.sell_in < 11 && self.sell_in > 5
      increase_quality_by(2)
    elsif self.sell_in < 6 && self.sell_in > 0
      increase_quality_by(3)
    else
      increase_quality_by(1)
    end
  end

  def increase_quality_by(amount)
    quality_going_beyond_fifthy?(amount) ? self.quality = 50 : increase_quality(amount)
  end

  private

  def quality_going_beyond_fifthy?(amount)
    self.quality + amount > 50
  end

  def increase_quality(amount)
    self.quality = self.quality + amount
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
    self.sell_in < 0 ? decrease_quality_by(2) : decrease_quality_by(1)
  end
end

class ConjuredItemDecorator < ItemDecorator
  def calculate
    update_sell_in
    update_quality
  end

  def update_quality
    self.sell_in < 0 ? decrease_quality_by(4) : decrease_quality_by(2)
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
