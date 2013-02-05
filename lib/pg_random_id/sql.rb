module PgRandomId
  module Sql
    def install
      FILES.map {|f| read_file f}.join
    end
    
    def apply table, column, key, base
      key ||= rand(2**32)
      base ||= sequence_nextval "#{table}_#{column}_seq"
      "ALTER TABLE #{table} ALTER COLUMN #{column} SET DEFAULT pri_scramble(#{key}, #{base})"
    end
    
    private

    FILES = %w(scramble.sql)
    BASEDIR = File.dirname(__FILE__)
    
    def read_file filename
      File.read(File.expand_path(filename, BASEDIR))
    end
    
    def sequence_nextval sequence_name
      "nextval('#{sequence_name}'::regclass)"
    end
  end
end
