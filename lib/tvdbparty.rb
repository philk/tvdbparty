=begin rdoc
  This is a series of methods to access theTVDB's api.  You'll need an API key from TheTVDB to make it work.  It requires the absolutely amazing httparty gem (http://httparty.rubyforge.org/) which really does the heavy lifting for me.  It also requires curb (http://curb.rubyforge.org/) because it's faster and easier to use.
  Author::  Phil Kates (mailto:hawk684@gmail.com)
=end
require "rubygems"
require "httparty"
require "cgi"
require "curb"

class TVShow
  include HTTParty
  format :xml
  attr_accessor :mirror, :api_key, :series_name, :series_id, :series_info, :episodes, :actors
  def initialize(api_key, params)
    @api_key = api_key
    @series_name = params[:series_name]
    @series_id = params[:series_id]
    begin
      # The code in the comment below should work, but it doesn't.  I get a ParseException from REXML, but REXML can process it just fine normally.  TODO Track this down
      # @mirror = self.class.get("www.thetvdb.com/api/#{@api_key}/mirrors.xml")["Mirrors"]["Mirror"]
      doc = REXML::Document.new(Curl::Easy.perform("www.thetvdb.com/api/#{@api_key}/mirrors.xml").body_str)
      total_mirrors = doc.elements["Mirrors"].get_elements("Mirror").size - 1
      if total_mirrors == 1
        @mirror = doc.elements["Mirrors"].get_elements("Mirror/mirrorpath")[0].text
      else
        @mirror = doc.elements["Mirrors"].get_elements("Mirror/mirrorpath")[rand(total_mirrors) - 1].text
      end
    rescue REXML::ParseException => e
      puts e
    end
    self.class.base_uri @mirror
  end
  def check_series_id
    if @series_id == nil
      if @series_name == nil
        raise "Series ID or Name must be set"
      else
        get_series_by_name
      end
    end
  end
  def get_series_by_name # TODO : Find series by name?
    res = self.class.get("/api/GetSeries.php?seriesname=" + CGI::escape(@series_name.to_s))
    if res["Data"].to_s =~ /.*connection to localhost.*/
      raise "TVDB API Down"
    else
      res = res["Data"]["Series"]
      @series_id = res["seriesid"]
    end
    if res.is_a?(Hash)
      return [res]
    elsif res.is_a?(Array)
      return res
    else
      raise "Unexpected Data Type Returned #{res.class}"
    end
  end
  # Returns nothing but sets the series_id and series_info
  def get_series_by_id
    check_series_id
    res = self.class.get("/api/#{@api_key}/series/#{@series_id}/en.xml")["Data"]["Series"]
    @series_id = res["seriesid"]
    @series_info = res
  end
  def get_series_info
    # TODO : Will return all info at once.
  end
  # Returns nothing but sets episodes value
  def get_episodes
    check_series_id
    @episodes = self.class.get("/api/#{@api_key}/series/#{@series_id}/all/en.xml")["Data"]["Episode"]
  end
  # Takes a string and returns the hash for the episode requested.
  def find_episode(number)
    if @episodes == nil
      get_episodes
    end
    if number.is_a?(String)
      @episodes.select {|episode| episode["EpisodeNumber"] == number}
    else
      raise "String Needed"
    end
  end
end

tvshow = TVShow.new("BC7240CD299E99B5", :series_name => "Eli Stone")