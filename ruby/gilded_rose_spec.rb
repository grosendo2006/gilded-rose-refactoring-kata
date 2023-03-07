require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do

  let(:aged_brie) { Item.new(name="Aged Brie", sell_in=2, quality=0) }
  let(:dexterity) { Item.new(name="+5 Dexterity Vest", sell_in=10, quality=20) }
  let(:elixir) { Item.new(name="Elixir of the Mongoose", sell_in=5, quality=7) }
  let(:sulfuras_1) { Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=0, quality=80) }
  let(:sulfuras_2) { Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=-1, quality=80) }
  let(:backstage_name) { "Backstage passes to a TAFKAL80ETC concert" }
  let(:backstage_1) { Item.new(name=backstage_name, sell_in=15, quality=20) }
  let(:backstage_2) { Item.new(name=backstage_name, sell_in=10, quality=49) }
  let(:backstage_5) { Item.new(name=backstage_name, sell_in=10, quality=45) }
  let(:backstage_3) { Item.new(name=backstage_name, sell_in=5, quality=49) }
  let(:backstage_4) { Item.new(name=backstage_name, sell_in=5, quality=30) }
  let(:backstage_6) { Item.new(name=backstage_name, sell_in=0, quality=30) }
  let(:conjured) { Item.new(name="Conjured", sell_in=3, quality=30) }
  let(:conjured_sell_in_passed) { Item.new(name="Conjured", sell_in=-1, quality=30) }
  let(:items) { [aged_brie, dexterity, elixir, sulfuras_1, sulfuras_2, backstage_1, backstage_2, backstage_3, backstage_4] }

  describe '#update_quality' do
    subject { described_class.new(items).update_quality() }

    context 'when is a regular item' do
      let(:items) { [dexterity, elixir] }
      let(:item) { items.sample }

      it 'decreases in quality' do
        expect { subject }.to change(item, :quality).by(-1)
      end

      it 'decreases the sell in' do
        expect { subject }.to change(item, :sell_in).by(-1)
      end
    end

    context 'when the item is a Conjured' do
      let(:items) { [conjured] }

      it 'increases in quality' do
        expect { subject }.to change(conjured, :quality).from(30).to(28)
      end

      it 'decreases the sell in' do
        expect { subject }.to change(conjured, :sell_in).from(3).to(2)
      end

      context 'when sell in passed' do
        let(:items) { [conjured_sell_in_passed] }

        it 'decreases the quality twice faster' do
          expect { subject }.to change(conjured_sell_in_passed, :quality).from(30).to(26)
        end

        it 'decreases the sell in' do
          expect { subject }.to change(conjured_sell_in_passed, :sell_in).from(-1).to(-2)
        end
      end
    end

    context 'when the item is an Aged Brie' do
      let(:items) { [aged_brie] }

      it 'increases in quality' do
        expect { subject }.to change(aged_brie, :quality).from(0).to(1)
      end

      it 'decreases the sell in' do
        expect { subject }.to change(aged_brie, :sell_in).from(2).to(1)
      end
    end

    context 'when the item is a Sulfuras' do
      let(:items) { [sulfuras_1, sulfuras_2] }

      it 'doesn\'t change the quality' do
        expect { subject }.to_not change(sulfuras_1, :quality)
        expect { subject }.to_not change(sulfuras_2, :sell_in)
      end

      it 'doesn\'t change the sell in' do
        expect { subject }.to_not change(sulfuras_1, :quality)
        expect { subject }.to_not change(sulfuras_2, :sell_in)
      end
    end

    context 'when the item is a Backstage passes' do
      let(:items) { [backstage_1] }

      it 'increases in quality' do
        expect { subject }.to change(backstage_1, :quality).from(20).to(21)
      end

      it 'decreases the sell in' do
        expect { subject }.to change(backstage_1, :sell_in).from(15).to(14)
      end

      context 'when there are 10 days or less' do
        let(:items) { [backstage_2, backstage_5] }

        it 'increases the quality by 2' do
          expect { subject }.to change(backstage_5, :quality).from(45).to(47)
        end

        it 'decreases the sell in' do
          expect { subject }.to change(backstage_5, :sell_in).from(10).to(9)
        end

        context 'when quality is near the maximun' do
          it 'the quality is never bigger than 50' do
            expect { subject }.to change(backstage_2, :quality).from(49).to(50)
          end

          it 'decreases the sell in' do
            expect { subject }.to change(backstage_2, :sell_in).from(10).to(9)
          end
        end
      end

      context 'when there are 5 days or less' do
        let(:items) { [backstage_3, backstage_4] }

        it 'increases the quality by 3' do
          expect { subject }.to change(backstage_4, :quality).from(30).to(33)
        end

        it 'decreases the sell in' do
          expect { subject }.to change(backstage_4, :sell_in).from(5).to(4)
        end

        context 'when quality is near the maximun' do
          it 'the quality is never bigger than 50' do
            expect { subject }.to change(backstage_3, :quality).from(49).to(50)
          end

          it 'decreases the sell in' do
            expect { subject }.to change(backstage_3, :sell_in).from(5).to(4)
          end
        end
      end

      context 'when the sell in day passed' do
        let(:items) { [backstage_6] }

        it 'drops the quality to 0' do
          expect { subject }.to change(backstage_6, :quality).from(30).to(0)
        end

        it 'decreases the sell in' do
          expect { subject }.to change(backstage_6, :sell_in).from(0).to(-1)
        end
      end
    end
  end
end
