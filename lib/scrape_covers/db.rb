require 'pg'

module ScrapeCovers
  class Db
    class << self
      def connection_params
        {
          host: ScrapeCovers.db_host,
          dbname: ScrapeCovers.db_name,
          user: ScrapeCovers.db_user,
          password: ScrapeCovers.db_password
        }
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

      def create_results_table
        sql = %Q{CREATE TABLE results (
          id              integer primary key,
          result_date     date,
          team            varchar(50),
          team_id         integer,
          opponent        varchar(50),
          opponent_id     integer,
          team_score      integer,
          opponent_score  integer,
          line            numeric,
          over_under      numeric
        );}
        connection.exec(sql)
      end

      def create_teams_table
      end

    end

  end
end
