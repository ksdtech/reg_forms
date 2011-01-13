##
# A MySQL connection:
# DataMapper.setup(:default, 'mysql://user:password@localhost/the_database_name')
#
# # A Postgres connection:
# DataMapper.setup(:default, 'postgres://user:password@localhost/the_database_name')
#
# # A Sqlite3 connection
# DataMapper.setup(:default, "sqlite3://" + Padrino.root('db', "development.db"))
#


DataMapper.logger = logger

# case Padrino.env
#  when :development then DataMapper.setup(:default, "sqlite3://" + Padrino.root('db', "jqforms_development.db"))
#  when :production  then DataMapper.setup(:default, "sqlite3://" + Padrino.root('db', "jqforms_production.db"))
#  when :test        then DataMapper.setup(:default, "sqlite3://" + Padrino.root('db', "jqforms_test.db"))
# end

# DATAMAPPER_OPTS read from app_config.yml, in boot.rb
datamapper_uri = configatron.datamapper.gsub("{{PADRINO_ROOT}}", Padrino.root)
DataMapper.setup(:default, datamapper_uri)
