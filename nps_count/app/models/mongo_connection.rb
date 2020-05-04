class MongoConnection
  include Singleton
  attr_reader :db, :client

  def initialize
    @client = Mongo::Client.new('mongodb://db:27017/nps_count')
    @db = @client.database
  end
end
