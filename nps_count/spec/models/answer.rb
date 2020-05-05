class Answer
  attr_accessor :grade, :company
  attr_reader :timestamp

  def timestamp=(date)
    @timestamp = date.strftime('%Y-%m-%dT%H:%M:%S.%L%z')
  end
end
