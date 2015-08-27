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
        puts "Connected to: #{ScrapeCovers.db_name}\n"
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
        sql = query_logger {
          %Q{
            SELECT EXISTS (
              SELECT 1
              FROM   information_schema.tables
              WHERE  table_name = '#{table_name}'
            );
          }
        }
        connection.exec(sql).each do |result|
          return result.fetch('exists', false) == 't'
        end
      end

      def create_database
        base_connection = PG.connect( base_connection_params )
        sql = query_logger {"CREATE DATABASE #{ScrapeCovers.db_name}"}
        base_connection.exec(sql)
        base_connection.close
      end

      def create_results_table
        puts "CREATE TABLE results"
        sql = query_logger {
          %Q{CREATE TABLE results (
            id              serial primary key,
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
        }
        connection.exec(sql)
      end

      def create_teams_table
        puts "CREATE TABLE teams"
        sql = query_logger {
          %Q{CREATE TABLE teams (
            id              serial primary key,
            covers_id       integer,
            name            varchar(50)
          );}
        }
        connection.exec(sql)
      end

      def seed_teams
        teams = Teams.nfl_teams
        teams.each do |covers_id, name|
          upsert_team(covers_id: covers_id, name: name)
        end
      end

      def upsert_team(team_args)
        result = find_team_by_covers_id(team_args[:covers_id])
        return result unless result.nil?

        sql = query_logger {
          "INSERT INTO teams (covers_id, name) VALUES(#{team_args[:covers_id]}, '#{team_args[:name]}') RETURNING id;"
        }
        connection.exec(sql)[0]
      end

      def find_team_by_covers_id(covers_id)
        sql = query_logger {
          "SELECT * FROM teams where covers_id = #{covers_id}"
        }
        result = connection.exec(sql)[0]
      rescue IndexError => e
        return nil
      end

      def find_team_by_id(id)
        sql = query_logger {
          "SELECT * FROM teams where id = #{id}"
        }
        result = connection.exec(sql)[0]
      rescue IndexError => e
        return nil
      end

      def all_teams
        sql = query_logger {
          "SELECT * FROM teams;"
        }
        result = connection.exec(sql)
      end

      def query_logger &block
        sql = yield
        puts "SQL: #{sql}" if ScrapeCovers.log_sql_queries
        sql
      end

      def reset_db
        sql = "DELETE FROM results;"
        connection.exec(sql)
        sql = "DELETE FROM teams;"
        connection.exec(sql)
      end

    end

  end
end
