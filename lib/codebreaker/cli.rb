# frozen_string_literal: true

module Codebreaker
  # Receive incoming data through the console
  # Comunication with the user using Internationalization
  class Cli
    attr_accessor :code, :exit_game
    attr_reader :game

    def initialize(game = Game.new)
      @game = game
      @code = ''
      @exit_game = false
    end

    def run
      puts I18n.t(:welcome)
      puts I18n.t(:choose_option)
      console_comands_checker(input_user)
    end

    private

    def input_user
      STDIN.gets.chomp.downcase
    end

    def console_comands_checker(input)
      case input
      when 'start' then start_game
      when 'rules' then rules
      when 'stats' then statistick
      when 'exit' then goodbuy
      when 'hint' then show_hint
      when /^[1-6]{4}$/ then result(input)
      else
        puts input.match(/^[0-9]+$/) ? I18n.t(:wrong_input_code) : I18n.t(:wrong_input_option)
        console_comands_checker(input_user)
      end
    end

    def goodbuy
      @exit_game = true
      puts I18n.t(:goodbye)
    end

    def rules
      puts I18n.t(:rules)
      puts I18n.t(:choose_option)
      console_comands_checker(input_user)
    end

    def start_game
      if game.user.nil?
        set_name
        set_choose_difficulty while game.hints.nil?
        !game.atempts.nil? ? atempts_counter : false
        you_lose
      else
        puts I18n.t(:wrong_input_option)
      end
    end

    def atempts_counter
      while game.atempts.positive? && check_result == false && @exit_game == false
        puts I18n.t(:message_guess_code)
        console_comands_checker(input_user)
        check_result unless code.nil?
        puts game.atempts
      end
    end

    def check_result
      code.match(/[+]{4}/) ? you_win : false
    end

    def set_name
      puts I18n.t(:write_name)
      puts I18n.t(:unexpected_name) until game.validator_name(input_user)

      puts I18n.t(:greeting)
    end

    def set_choose_difficulty
      puts I18n.t(:choose_difficulty)
      if game.choose_difficulty(input_user) == false
        puts I18n.t(:wrong_input_option)
      end
      #return puts I18n.t(:wrong_input_option) if game.choose_difficulty(input_user) == false
    end

    def result(input)
      @code = game.compare_code(input)
      puts game.user.nil? ? false : code
    end

    def show_hint
      puts game.user.nil? ? console_comands_checker('input_user') : game.hint
    end

    def restart
      puts I18n.t(:restart)
      if input_user.downcase == 'yes'
        initialize
        start_game
      else
        goodbuy
      end
    end

    def you_win
      puts I18n.t(:win)
      p game.secrete_code
      statistick
      restart
    end

    def you_lose
      puts I18n.t(:lose)
      p game.secrete_code
      restart
    end

    def statistick
      if game.stat.empty?
        puts I18n.t(:clear_stats)
        puts I18n.t(:choose_option)
        console_comands_checker(input_user)
      else
        puts "Difficult: #{game.stat[:diff]}"
        puts "Hints used: #{game.stat[:hint] - game.hints}"
        puts "Atempts used: #{game.stat[:atempts] - game.atempts}"
      end
    end
  end
end
