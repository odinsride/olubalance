# A document belongs to one account. An account may have many documents. Useful for storing
# statements or correspondence regarding the account.
class Document < ApplicationRecord
  belongs_to :account, optional: true

  has_attached_file :file,
                    # In order to determine the styles of the image we want to save
                    # e.g. a small style copy of the image, plus a large style copy
                    # of the image, call the check_file_type method
                    styles: { large: ['1000x1000>', :png], medium: ['300x300>', :png], thumb: ['100x100>', :png] }

  # Validate that we accept the type of file the user is uploading
  # by explicitly listing the mimetypes we are willing to accept
  validates_attachment_content_type :file,
                                    content_type: [
                                      'image/jpg',
                                      'image/jpeg',
                                      'image/png',
                                      'image/gif',
                                      'application/pdf',

                                      'file/txt',
                                      'text/plain',

                                      'application/doc',
                                      'application/msword',

                                      'application/vnd.ms-excel',
                                      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
                                    ],
                                    message: 'Sorry! We do not accept the attached file type'

  before_post_process :rename_file

  private

  def rename_file
    extension = File.extname(file_file_name).downcase
    file.instance_write :file_name, "#{id}_#{document_date.strftime('%Y-%m-%d')}#{extension}"
  end

end
