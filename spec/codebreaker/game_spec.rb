# frozen_string_literal: true

module Codebreaker
  RSpec.describe Game do
    subject(:game) { Codebreaker::Game.new }

    describe '#compare_guess_and_secret_codes' do
      [
        [[1, 1, 1, 1], '1111', '++++'],
        [[5, 5, 6, 6], '5600', '+-'],
        [[1, 2, 3, 4], '4321', '----'],
        [[1, 2, 3, 4], '1235', '+++'],
        [[1, 2, 3, 4], '6254', '++'],
        [[1, 2, 3, 4], '5635', '+'],
        [[1, 2, 3, 4], '4326', '---'],
        [[1, 2, 3, 4], '3525', '--'],
        [[1, 2, 3, 4], '2552', '--'],
        [[1, 2, 3, 4], '4255', '+-'],
        [[1, 2, 3, 4], '1524', '++-'],
        [[1, 2, 3, 4], '5431', '+--'],
        [[1, 2, 3, 4], '2134', '++--'],
        [[1, 2, 3, 4], '6666', '']
      ].each do |item|
        it "return #{item[2]} if code is - #{item[0]}, guess_code is #{item[1]}" do
          game.instance_variable_set(:@secrete_code, item[0])
          expect(game.compare_code(item[1])).to eq item[2]
        end
      end
    end

    describe '#valid_secret_code' do
      it 'return array from 4 nums, beetwen 1 and 6' do
        game = described_class.new
        expect(game.secrete_code.join).to match(/^[1-6]{4}$/)
      end
    end

    describe '#choose_difficulty' do
      %w[easy medium hell].each do |item|
        it 'return set variables' do
          expect { game.choose_difficulty(item) }.to change(game, :hints).from(nil).to(Integer)
        end
      end
    end

    describe '#user_validation' do
      ['Alexander1234567890!!', 'GG'].each do |item|
        it 'must return false' do
          expect(game.validator_name(item)).to be_falsey
        end
      end
    end

    describe '#hints_counter' do
      try = 2
      it 'return minus one hint' do
        game.instance_variable_set(:@hints, try)
        expect { game.hint }.to change(game, :hints).from(2).to(1)
      end

      it 'return message if hint exist' do
        game.instance_variable_set(:@hints, 0)
        expect { print(I18n.t(:used_all_hints)) }.to output(game.hint).to_stdout
      end
    end
  end
end
