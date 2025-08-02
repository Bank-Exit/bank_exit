class DirectoryMailerPreview < ActionMailer::Preview
  def send_new_directory
    DirectoryMailer
      .with(
        directory_id: 1,
        proposition_from: 'johndoe@example.com'
      )
      .send_new_directory
  end
end
