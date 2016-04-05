require 'spec_helper'

describe Bittrex::Orderbook do
  let(:data){ fixture(:orderbook) }
  let(:subject){ Bittrex::Orderbook.new('BTC-HPY', data) }

  describe '#initialization' do
    it { should_assign_attribute(subject, :market, 'BTC-HPY') }
    it { should_assign_attribute(subject, :buy,  [{ quantity: 1, rate: 0.01607601 }, { quantity: 1.5, rate: 0.01607590 }]) }
    it { should_assign_attribute(subject, :sell, [{ quantity: 1, rate: 0.01633299 }, { quantity: 1.5, rate: 0.01633301 }]) }
  end
end
