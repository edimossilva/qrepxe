class AnswerCollection
  def self.save_many(data)
    collection.insert_many(data)
  end

  def self.save(data)
    collection.insert_one(data)
  end

  def self.collection
    MongoConnection.instance.client[:answers]
  end
end
