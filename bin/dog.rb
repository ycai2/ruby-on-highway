class Dog
  attr_reader :name, :owner

  def self.all
    @dogs ||= []
  end


  def self.find(id)
    @dogs[id]
  end

  def initialize(params = {})
    params ||= {}
    @name, @owner = params["name"], params["owner"]
  end

  def errors
    @errors ||= []
  end

  def valid?
    unless @owner.present?
      errors << "Owner can't be blank"
      return false
    end

    unless @name.present?
      errors << "Name can't be blank"
      return false
    end
    true
  end

  def save
    return false unless valid?

    Dog.all << self
    true
  end

  def inspect
    { name: name, owner: owner }.inspect
  end
end
