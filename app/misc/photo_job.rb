class PhotoJob
  @queue = :photo_processing

  def self.perform(photo_id)
    Photo.find(photo_id)
  end
  
end