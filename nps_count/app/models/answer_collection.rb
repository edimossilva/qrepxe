class AnswerCollection
  def self.all
    collection.find.map(&:to_json)
  end

  def self.collection
    MongoConnection.instance.client[:answers]
  end

  def self.save(data)
    collection.insert_one(data)
  end

  def self.save_many(data)
    collection.insert_many(data)
  end

  def self.find; end

  def self.promoters
    collection.find({ grade: { '$gt' => 8 } })
  end

  def self.promoters_count
    promoters.count
  end

  def self.passives
    collection.find({ grade: { '$gte': 7, '$lte': 8 } })
  end

  def self.passives_count
    passives.count
  end

  def self.detractors
    collection.find({ grade: { '$lt': 7 } })
  end

  def self.detractors_count
    detractors.count
  end
end
