# frozen_string_literal: true

module Codebreaker
  RSpec.describe Cli do
    subject(:cli) { Codebreaker::Cli.new(game) }

    let(:game) { Game.new }
    let(:code) { '1234' }
    let(:name) { 'Alex' }

    it 'output hello to console' do
      allow(STDIN).to receive(:gets).and_return('exit')
      expect { cli.run }.to output(/#{I18n.t(:welcome)}/).to_stdout
    end

    it 'output choose_option to console' do
      allow(STDIN).to receive(:gets).and_return('exit')
      expect { cli.run }.to output(/#{I18n.t(:choose_option)}/).to_stdout
    end

    it 'output wrong input option' do
      allow(STDIN).to receive(:gets).and_return('start', 'exit')
      allow(game).to receive(:user).and_return(name)
      expect { cli.run }.to output(/#{I18n.t(:wrong_input_option)}/).to_stdout
    end

    it 'output rules to console' do
      allow(STDIN).to receive(:gets).and_return('rules', 'exit')
      expect { cli.run }.to output(include(I18n.t(:rules))).to_stdout
    end

    it 'output stats alert message' do
      allow(STDIN).to receive(:gets).and_return('stats', 'exit')
      expect { cli.run }.to output(/#{I18n.t(:clear_stats)}/).to_stdout
    end
    #     it 'retur count of hint' do
    #       code = '1111'
    #       game.instance_variable_set(:@secrete_code, code.chars.map(&:to_i))
    #       allow(game).to receive(:hint).and_return('2')
    #       allow($stdin).to receive(:gets).and_return('start', 'Alex', 'medium', 'hint')
    #
    #       expect { cli.run }.to output('1').to_stdout
    #
    #       expect(game).to receive(:hint).with().and_return('2')
    #     end

    describe '#difficult_method_with_diff_values' do
      before do
        let(:game) { Game.new }
        allow(game).to receive(:secrete_code).and_return(code.chars.map(&:to_i))
      end

      it 'chose hell difficult' do
        allow(5).to receive(:gets).and_return('start', name, 'hell', code, 'exit')
        expect { cli.run }.to output(include(I18n.t(:win))).to_stdout
      end

      it 'chose easy difficult' do
        allow($stdin).to receive(:gets).and_return('start', name, 'easy', code, 'exit')
        expect { cli.run }.to output(include(I18n.t(:win))).to_stdout
      end

      it 'chose medium difficult' do
        allow($stdin).to receive(:gets).and_return('start', name, 'medium', code, 'exit')
        expect { cli.run }.to output(include(I18n.t(:win))).to_stdout
      end

      it 'chose wrong difficult' do
        allow($stdin).to receive(:gets).and_return('start', name, 'fff', 'exit')
        expect { cli.run }.to output(include(I18n.t(:wrong_input_option))).to_stdout
      end
    end

    it 'output hint message' do
      allow(STDIN).to receive(:gets).and_return('hint', 'exit')
      expect { cli.run }.to output(include(I18n.t(:wrong_input_option))).to_stdout
    end
  end
end
