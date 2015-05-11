require 'net/http'
require 'json'

class SearchController < ApplicationController

  def artist
    @artist_details_json = {}
    val = params[:search_string]
    @is_error = false
    data = getArtistDetails(val)
    @JSON_ARRAY_LIMIT = 10
    if (data == "something went wrong" or data == "search not found")
      @artist_details_json[:error => data]
    else

      artist_info = data['artist']
      validateParsedDetailsAndSet(artist_info, val)
      Srecord.create(:user_id => current_user.id, :search_string => val, :artistimage => @artist_pic, :artistprofile => @artist_link)

    end
    render :json => JSON.generate(@artist_details_json)
  end

  def validateParsedDetailsAndSet(artist_info, val)

    begin
      @artist_details_json.store(:name, artist_info['name'])
    rescue StandardError
      @artist_details_json.store(:name, 'ERROR PARSING NAME')
    end

    begin
      @artist_pic = artist_info['image'][3]['#text'];
      @artist_details_json.store(:image, @artist_pic)
    rescue StandardError
      @artist_details_json.store(:image, 'backup image')
    end

    begin
      @artist_link = artist_info['url'];
      @artist_details_json.store(:url, artist_info['url'])
    rescue StandardError
      @artist_details_json.store(:url, 'show broken')
    end

    begin
      similar_artists = artist_info['similar']['artist']
      if (similar_artists.kind_of?(Hash))
        similar_artists = [similar_artists]
      end
      similar_artists.each do |artist|
        artist.store('artistimage', artist['image'][3]['#text'])
        artist.delete('image')
      end
      @artist_details_json.store(:similar_artist, similar_artists)
    rescue StandardError
      @artist_details_json.store(:similar_artist, [])
    end

    begin
      tags = artist_info['tags']['tag']
      if (tags.kind_of?(Hash))
        tags = [tags]
      end
      @artist_details_json.store(:tags, tags)

    rescue StandardError
      @artist_details_json.store(:tags, [])
    end


    begin
      data = getAlbums(val)
      albums = []
      albums_info = data['topalbums']['album']
      if (albums_info.kind_of?(Hash))
        albums_info = [albums_info]
      end
      albums_info.each do |album|
        album.delete('artist')
        album.delete('mbid')
        album.delete('@attr')
        album.store('albumimage', album['image'][3]['#text'])
        album.delete('image')
      end
      @artist_details_json.store('albums', albums_info)
    rescue StandardError
      @artist_details_json.store(:albums, [])
    end

  end


  def getAlbums(artist)

    url = 'http://ws.audioscrobbler.com/2.0/?method=artist.gettopalbums&artist='+artist+'&api_key='+Rails.application.secrets.last_fm_api_key+'&format=json'
    resp = Net::HTTP.get_response(URI.parse(url)) # get_response takes an URI object
    return JSON.parse(resp.body)


  end

  def getArtistDetails(artist)

    url = 'http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist='+artist+'&api_key='+Rails.application.secrets.last_fm_api_key+'&format=json'
    begin
      resp = Net::HTTP.get_response(URI.parse(url)) # get_response takes an URI object
    rescue StandardError
      return "something went wrong"
    end
    data = JSON.parse(resp.body)
    if (data.has_key? 'error')
      return "search not found"
    else
      return data
    end
  end

end
