class Array

  def to_hash
    inject({}) do |hash, element|
      hash[element.first] = element.last
      hash
    end
  end

  def index_by
    hash = {}
    map { |n| hash[yield(n)] = n }
    hash
  end

  def subarray_count(subarray)
    each_cons(subarray.length).count(subarray)
  end

  def occurences_count
    hash = {}
    each { |element| hash[element] += 1 }
    hash
  end

end