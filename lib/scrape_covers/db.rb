require 'pg'

module ScrapeCovers
  class Db
    class << self
      def base_connection_params
        {
          host: ScrapeCovers.db_host,
          user: ScrapeCovers.db_user,
          password: ScrapeCovers.db_password
        }

      end

      def connection_params
        base_connection_params.merge({dbname: ScrapeCovers.db_name})
      end

      def connection
        @connection ||= PG.connect( connection_params )
      end

      def ping
        ping_result = PG::Connection.ping( connection_params )
        case ping_result
        when PG::PQPING_OK
          puts "server is accepting connections"
        when PG::PQPING_REJECT
          puts "server is alive but rejecting connections"
        when PG::PQPING_NO_RESPONSE
          puts "could not establish connections"
        when PG::PQPING_NO_ATTEMPT
          puts "connection not attempted (bad params)"
        else
          puts "Unknown ping error"
        end
      end

      def table_exists?(table_name)
        sql = %Q{
          SELECT EXISTS (
            SELECT 1
            FROM   information_schema.tables
            WHERE  table_name = '#{table_name}'
          );
        }
        connection.exec(sql).each do |result|
          return result.fetch('exists', false) == 't'
        end
      end

      def create_database
        base_connection = PG.connect( base_connection_params )
        sql = "CREATE DATABASE #{ScrapeCovers.db_name}"
        base_connection.exec(sql)
        base_connection.close
      end

      def create_results_table
        puts "CREATE TABLE results"
        sql = %Q{CREATE TABLE results (
          id              integer primary key,
          date            date,
          home_team       varchar(50),
          home_team_id    integer,
          away_team       varchar(50),
          away_team_id    integer,
          home_team_score integer,
          away_team_score integer,
          line            numeric,
          over_under      numeric
        );}
        connection.exec(sql)
      end

      def create_teams_table
        puts "CREATE TABLE teams"
        sql = %Q{CREATE TABLE teams (
          id              integer primary key,
          covers_id       integer,
          team_name       varchar(50)
        );}
        connection.exec(sql)
      end

      def upsert_team(team)
      end

      def upsert_results(result)
      end

    end

  end
end
