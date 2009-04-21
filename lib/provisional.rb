$:.unshift File.dirname(__FILE__)

require 'provisional/project'

module Provisional
  IGNORE_FILES = [
    ['coverage'],
    ['config/database.yml'],
    ['db/*.sqlite3'],
    ['log/*.log'],
    ['tmp/restart.txt'],
    ['tmp/cache/*'],
    ['tmp/pids/*'],
    ['tmp/sessions/*'],
    ['tmp/sockets/*']
  ]
end
