=begin rdoc
  Author:  Phil Kates (mailto:me@philkates.com)
=end
require "rubygems"
require "httparty"
require "cgi"
require "uri"
require "net/http"
require "tvdbmapper"

=begin rdoc
Create a TVShow.new like this.
  tvshow = TVShow.new(:series_name => "The Wire")
OR
  tvshow = TVShow.new(:series_id => "79126")
=end
class TVShow
  include HTTParty
  format :xml
  attr_accessor :mirror, :series_name, :series_id, :series, :actors, :episodes, :banners
  def initialize(params)
    @api_key = "BC7240CD299E99B5"
    @series_name = params[:series_name]
    @series_id = params[:series_id]
    result = self.class.get("http://www.thetvdb.com/api/#{@api_key}/mirrors.xml")
    @mirror = result["Mirrors"]["Mirror"]["mirrorpath"]
    self.class.base_uri @mirror
  end
  def get_series_by_name # TODO : Find series by name?
    res = self.class.get("/api/GetSeries.php?seriesname=" + CGI::escape(@series_name.to_s))
    if res["Data"].to_s =~ /.*connection to localhost.*/
      raise "TVDB API Down"
    else
      res = res["Data"]["Series"]
    end
    if res.is_a?(Hash)
      @series_id = res["seriesid"]
      return [res]
    elsif res.is_a?(Array)
      return res
    else
      raise "Unexpected Data Type Returned #{res.class}"
    end
  end
  def get_series_as_zip(path)
    check_series_id
    if path.is_a? String
      path = Pathname.new(path)
    end
    res = Net::HTTP.get URI.parse("http://zip.thetvdb.com/data/zip/en/#{@series_id}.zip")
    file = File.open(path + "testing.zip", 'w')
    file.write(res)
    file.close

    zipfile = Zip::ZipFile.open(path + "testing.zip")
    zipfile.extract("en.xml", path + "en.xml")
    zipfile.extract("actors.xml", path + "actors.xml")
    zipfile.extract("banners.xml", path + "banners.xml")
    zipfile.close

    @series_xml = File.open(path + "en.xml", 'r').readlines.to_s
    @actor_xml = File.open(path + "actors.xml", 'r').readlines.to_s
    @banner_xml = File.open(path + "banners.xml", 'r').readlines.to_s

    @series = TVDBMapper::Series.parse(@series_xml).first
    @episodes = TVDBMapper::Episodes.parse(@series_xml)
    @actors = TVDBMapper::Actors.parse(@actor_xml)
    @banners = TVDBMapper::Banners.parse(@banner_xml)

    FileUtils.rm(path + "en.xml")
    FileUtils.rm(path + "actors.xml")
    FileUtils.rm(path + "banners.xml")
    FileUtils.rm(path + "testing.zip")
  end
  def find_by_episode(season, episode_number)
    season = season.to_s
    episode_number = episode_number.to_s
    @episodes.select { |e| e.number == episode_number && e.season == season }.first
  end
  def get_episode_banner(image_path)
    Net::HTTP.get URI.parse("http://images.thetvdb.com/banners/#{image_path}")
  end
  private
    def check_series_id
      if @series_id == nil
        raise "series_id must not be nil"
      end
    end
end