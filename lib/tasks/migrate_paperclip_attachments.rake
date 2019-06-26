# frozen_string_literal: true

namespace :migrate_paperclip do
  desc 'Migrate the paperclip attachments'
  task move_attachments: :environment do
    # Eager load the application so that all Models are available
    Rails.application.eager_load!

    # Get a list of all the models in the application
    models = ActiveRecord::Base.descendants.reject(&:abstract_class?)

    # Loop through all the models found
    models.each do |model|
      puts 'Checking Model [' + model.to_s + '] for Paperclip attachment columns ...'

      # If the model has a column or columns named *_file_name,
      # We are assuming this is a column added by Paperclip.
      # Store the name of the attachment(s) found (e.g. "avatar") in an array named attachments
      attachments = model.column_names.map do |c|
        Regexp.last_match(1) if c =~ /(.+)_file_name$/
      end.compact

      # For
      attachments.each do |attachment|
        migrate_attachment(attachment, model)
      end
    end
  end
end

private

def migrate_attachment(attachment, model)
  model.where.not("#{attachment}_file_name": nil).find_each do |instance|
    # Set the S3 Bucket based on environment
    bucket = Rails.env.production? ? ENV['S3_BUCKET_NAME'] : ENV['S3_BUCKET_NAME_DEV']
    region = ENV['S3_REGION']

    # Set attachment details
    instance_id = instance.id
    filename = instance.send("#{attachment}_file_name")
    extension = File.extname(filename)
    content_type = instance.send("#{attachment}_content_type")
    original = CGI.unescape(filename.gsub(extension, "_original#{extension}"))

    # puts '  [' + model.name + ' (ID: ' +
    #      instance_id.to_s + ')] ' \
    #      'Copying to ActiveStorage location: ' + original

    # Paperclip stores attachments in a directory structure such as:
    # 000/000/001 = Instance ID 1
    # 000/050/250 = Instance ID 50250
    # 999/999/999 = Instance ID 999999999
    # We need to build the appropriate path to get the correct URL for the attachment
    instance_path = instance_id.to_s.rjust(9, "0")
    instance_path = instance_path.scan(/.{1,3}/).join("/")

    # Build the S3 URL
    url = "https://#{bucket}.s3.#{region}.amazonaws.com/#{model.name.downcase.pluralize}/#{attachment.pluralize}/#{instance_path}/original/#{filename}"
    puts '    ' + url

    # Copy the original Paperclip attachment to its new ActiveStorage location
    # For debugging/testing purposes, comment out this section and print the URL to log to verify the correctness
    # instance.send(attachment.to_sym).attach(
    #   io: open(url),
    #   filename: filename,
    #   content_type: content_type
    # )
  end
end
