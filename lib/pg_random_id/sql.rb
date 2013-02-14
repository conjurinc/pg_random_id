module PgRandomId
  module Sql
    class << self
      def install
        FILES.map {|f| read_file f}.join
      end
      
      def uninstall
        """
          DROP FUNCTION crockford(input bigint);
          DROP FUNCTION pri_scramble(key bigint, input bigint);
        """
      end
      
      def apply table, column, options = {}
        key = options[:key] || rand(2**15)
        base = options[:base] || sequence_nextval("#{table}_#{column}_seq")
        "ALTER TABLE #{table} ALTER COLUMN #{column} SET DEFAULT pri_scramble(#{key}, #{base})"
      end
      
      def unapply table, column, options = {}
        base = options[:base] || sequence_nextval("#{table}_#{column}_seq")
        """
          ALTER TABLE #{table} ALTER COLUMN #{column} SET DEFAULT #{base};
          ALTER TABLE #{table} ALTER COLUMN #{column} SET DATA TYPE integer USING 0;
        """
      end
      
      def apply_str table, column, options = {}
        key = options[:key] || rand(2**15)
        base = options[:base] || sequence_nextval("#{table}_#{column}_seq")
        type = options[:type] || "character(6)"
        """
          ALTER TABLE #{table} ALTER COLUMN #{column} SET DATA TYPE #{type};
          ALTER TABLE #{table} ALTER COLUMN #{column} SET DEFAULT lpad(crockford(pri_scramble(#{key}, #{base})), 6, '0');
        """
      end
      
      private

      FILES = %w(scramble.sql crockford.sql)
      BASEDIR = File.expand_path 'sql', File.dirname(__FILE__)
      
      def read_file filename
        File.read(File.expand_path(filename, BASEDIR))
      end
      
      def sequence_nextval sequence_name
        "nextval('#{sequence_name}'::regclass)"
      end
    end
  end
end
