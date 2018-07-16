require 'spec_helper'

RSpec.describe Hydra::Works::Characterization::FitsDocument, no_clean: true do
  let(:terms) do
    %i(
      fits_version
      format_label
      file_mime_type
      exif_tool_version
      file_size
      date_modified
      filename
      original_checksum
      date_created
      rights_basis
      copyright_basis
      copyright_note
      well_formed
      valid
      filestatus_message
      file_title
      file_author
      page_count
      file_language
      word_count
      character_count
      paragraph_count
      line_count
      table_count
      graphics_count
      byte_order
      compression
      width
      video_width
      video_track_width
      height
      video_height
      video_track_height
      color_space
      profile_name
      profile_version
      orientation
      color_map
      image_producer
      capture_device
      scanning_software
      exif_version
      gps_timestamp
      latitude
      longitude
      character_set
      markup_basis
      markup_language
      audio_duration
      video_duration
      bit_depth
      audio_sample_rate
      video_sample_rate
      video_audio_sample_rate
      channels
      data_format
      offset
      frame_rate
      audio_bit_rate
      video_bit_rate
      track_frame_rate
      aspect_ratio
    )
  end

  let(:doc) { described_class.new }

  it 'responds to terms' do
    terms.each do |term|
      expect(doc).to respond_to term
    end
  end
end
