module PgRandomId
  module Sql
    class << self
      def install
        FILES.map {|f| read_file f}.join
      end
      
      def uninstall
        read_file 'uninstall.sql'
      end
      
      def apply table, column, options = {}
        key = options[:key] || rand(2**15)
        sequence = options[:sequence] || "#{table}_#{column}_seq"
        """
          INSERT INTO pri_keys VALUES ('#{sequence}'::regclass, #{key});
          ALTER TABLE #{table} ALTER COLUMN #{column} SET DEFAULT pri_nextval('#{sequence}'::regclass);
        """
      end
      
      def unapply table, column, options = {}
        sequence = options[:sequence] || "#{table}_#{column}_seq"
        """
          ALTER TABLE #{table} ALTER COLUMN #{column} SET DEFAULT nextval('#{sequence}'::regclass);
          ALTER TABLE #{table} ALTER COLUMN #{column} SET DATA TYPE integer USING 0;
          DELETE FROM pri_keys WHERE sequence = '#{sequence}'::regclass;
        """
      end
      
      def apply_str table, column, options = {}
        key = options[:key] || rand(2**15)
        sequence = options[:sequence] || "#{table}_#{column}_seq"
        type = options[:type] || "character(6)"
        """
          INSERT INTO pri_keys VALUES ('#{sequence}'::regclass, #{key});
          ALTER TABLE #{table} ALTER COLUMN #{column} SET DATA TYPE #{type};
          ALTER TABLE #{table} ALTER COLUMN #{column} SET DEFAULT pri_nextval_str('#{sequence}'::regclass);
        """
      end
      
      private

      FILES = %w(scramble.sql crockford.sql keytable.sql)
      BASEDIR = File.expand_path 'sql', File.dirname(__FILE__)
      
      def read_file filename
        File.read(File.expand_path(filename, BASEDIR))
      end
    end
  end
end
