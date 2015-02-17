module FutureWrapper
  def[](key)
    response = value
    if response[key].present?
      response[key]
    else
      response.body[key]
    end
  end

  def method_missing(sym, *args, &block)
    response = value
    if response.respond_to? sym
      response.send sym, *args, &block
    else
      response.body.send sym, *args, &block
    end
  end
end

