# frozen_string_literal: true

module Codebreaker
  # Generation secret code for each instance, validation names for users,
  # setting count hints and atemps, comparing secter and guest codeds
  class Game
    attr_accessor :hints, :atempts, :user, :hint_char, :creepted_code, :stat
    attr_reader :secrete_code, :secret_code_for_hints

    NAME_LENGTH_RANGE = (3..20).freeze

    def initialize
      @user = nil
      @stats = nil
      @hints = nil
      @atempts = nil
      @creepted_code = []
      @secrete_code = generate_secrete_code
      @secret_code_for_hints = @secrete_code.shuffle
      @stat = {}
    end

    def generate_secrete_code
      4.times.map { rand(1..6) }
    end

    def validator_name(input_name)
      NAME_LENGTH_RANGE.include?(input_name.length) ? self.user = input_name : false
    end

    def hint
      if hints.positive?
        self.hints -= 1
        @secret_code_for_hints.pop
      else
        I18n.t(:used_all_hints)
      end
    end

    def compare_code(guess_code)
      self.atempts -= 1 unless atempts.nil?
      guess_code_arr = guess_code.chars.map(&:to_i)
      guess_code_arr.map.with_index do |x, index|
        if x == secrete_code[index]
          '+'
        else
          secrete_code.include?(x) ? '-' : ''
        end
      end.sort.join
    end

    def choose_difficulty(input)
      case input
      when 'easy'
        self.hints = 2
        self.atempts = 15
        self.stat = { hint: 2, atempts: 15, diff: 'Easy' }
      when 'medium'
        self.hints = 1
        self.atempts = 10
        self.stat = { hint: 1, atempts: 10, diff: 'Medium' }
      when 'hell'
        self.hints = 1
        self.atempts = 5
        self.stat = { hint: 1, atempts: 5, diff: 'Hard' }
      else
        false
      end
    end
  end
end
