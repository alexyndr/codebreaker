# frozen_string_literal: true

require 'i18n'

module Codebreaker
  I18n.load_path << Dir[File.expand_path('../config/locales/') + '/*.yml']
end
