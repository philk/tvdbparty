require "rubygems"
require "zip/zip"
require "happymapper"

module TVDBMapper
  class Series
    include HappyMapper
    tag 'Series'

    element :id, String, :tag => "id"
    element :actors, String, :tag => "Actors"
    element :overview, String, :tag => "Overview"
    element :seriesid, String, :tag => "SeriesID"
    element :seriesname, String, :tag => "SeriesName"
    element :genre, String, :tag => "Genre"
    element :imdb, String, :tag => "IMDB_ID"
    element :language, String, :tag => "Language"
    element :network, String, :tag => "Network"
    element :rating, String, :tag => "Rating"
    element :zap2it, String, :tag => "zap2it_id"
  end
  class Episodes
    include HappyMapper
    tag 'Episode'
    
    element :id, String, :tag => "id"
    element :name, String, :tag => "EpisodeName"
    element :director, String, :tag => "Director"
    element :number, String, :tag => "EpisodeNumber"
    element :name, String, :tag => "value"
    element :overview, String, :tag => "Overview"
    element :season, String, :tag => "SeasonNumber"
    element :writer, String, :tag => "Writer"
    element :banner, String, :tag => "filename"
    element :airdate, String, :tag => "FirstAired"
  end
  class Banners
    include HappyMapper
    tag 'Banner'
    
    element :id, String, :tag => "id"
    element :path, String, :tag => "BannerPath"
    element :type, String, :tag => "BannerType"
    element :type2, String, :tag => "BannerType2"
    element :language, String, :tag => "Language"
    element :thumb, String, :tag => "ThumbnailPath"
    element :vignette, String, :tag => "VignettePath"
  end
  class Actors
    include HappyMapper
    tag 'Actor'
    
    element :id, String, :tag => "id"
    element :image, String, :tag => "Image"
    element :name, String, :tag => "Name"
    element :role, String, :tag => "Role"
    element :sortorder, String, :tag => "SortOrder"
  end
end