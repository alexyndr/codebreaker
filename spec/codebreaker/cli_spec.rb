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
      expect { cli.run }.to output(include(I18n.t(:wrong_input_option))).to_stdout
    end

    it 'output rules to console' do
      allow(STDIN).to receive(:gets).and_return('rules', 'exit')
      expect { cli.run }.to output(include(I18n.t(:rules))).to_stdout
    end

    it 'output stats alert message' do
      allow(STDIN).to receive(:gets).and_return('stats', 'exit')
      expect { cli.run }.to output(/#{I18n.t(:clear_stats)}/).to_stdout
    end

    it 'output hint message' do
      allow(STDIN).to receive(:gets).and_return('hint', 'exit')
      expect { cli.run }.to output(include(I18n.t(:wrong_input_option))).to_stdout
    end

    describe '#difficult_method_with_diff_values' do
      before do
        allow(game).to receive(:secrete_code).and_return(code.chars.map(&:to_i))
      end

      it 'chose hell difficult' do
        allow(STDIN).to receive(:gets).and_return('start', name, 'hell', code, 'exit')
        expect { cli.run }.to output(include(I18n.t(:win))).to_stdout
      end

      it 'chose easy difficult' do
        allow(STDIN).to receive(:gets).and_return('start', name, 'easy', code, 'exit')
        expect { cli.run }.to output(include(I18n.t(:win))).to_stdout
      end

      it 'chose medium difficult' do
        allow(STDIN).to receive(:gets).and_return('start', name, 'medium', code)
        expect { cli.run }.to output(include(I18n.t(:win))).to_stdout
      end

      it 'chose wrong difficult' do
        allow(STDIN).to receive(:gets).and_return('start', name, 'fff', 'medium', 'exit')
        expect { cli.run }.to output(include(I18n.t(:wrong_input_option))).to_stdout
      end
    end
  end
end
