class Song

  attr_reader :name, :artist, :genre, :subgenre, :tags

  def initialize(name, artist, genre, subgenre, tags)
    @name, @artist, @genre = name, artist, genre
    @subgenre, @tags       = subgenre, tags
  end

  def matches?(criteria)
    criteria.all? do |type,value|
      case type
        when :name    then :name == value
        when :artist  then :artist == value
        when :filter  then value.(self)
        when :tags    then Array(value).all? { |tag| matches_tag? tag }
      end
    end
  end

  def matches_tag?(tag)
    tag.end_with?("!") ? ( not tags.include?(tag.chomp "!") ) : tags.include?(tag)
  end

end

class Collection

  def initialize(songs_string, artist_tags)
    @collection = songs_string.lines.map { |song| song.split(".").map(&strip) }
    @collection.map do |name, artist, genres, tags_string|
      genre, subgenre = genres.split(",").map(&strip)
      tags = artist_tags.fetch(artist, [])
      tags += [genre,subgenre].compact.map(&:downcase)
      tags += tags_string.split(",").map(&:strip) unless tags_string.nil?

      Song.new(name, artist, genre, subgenre, tags)
    end
  end

  def find(criteria)
    @collection.select { |song | song.matches?(criteria) }
  end

end