class DirectoryMailer < ApplicationMailer
  def send_new_directory
    @directory_id = params[:directory_id]
    @proposition_from = params[:proposition_from]

    # Store a TXT copy version of the mail in backup waiting
    # to have a working SMTP configuration.
    EmailAsTextFile.call(
      'directory_mailer/send_new_directory',
      directory_id: @directory_id,
      proposition_from: @proposition_from
    )

    mail reply_to: @proposition_from
  end
end
