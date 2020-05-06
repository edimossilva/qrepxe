class Answer
  attr_accessor :grade, :company
  attr_reader :timestamp

  def timestamp=(date)
    @timestamp = date.strftime('%Y-%m-%dT%H:%M:%S.%L%z')
  end

  def self.all
    collection.find.map(&:to_json)
  end

  def self.collection
    MongoConnection.instance.client[:answers]
  end

  def self.companies
    collection.distinct('company')
  end

  def self.save(data)
    collection.insert_one(data)
  end

  def self.save_many(data)
    collection.insert_many(data)
  end
end
