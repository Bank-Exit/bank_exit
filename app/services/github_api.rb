class GithubAPI
  include HTTParty

  base_uri 'https://api.github.com'

  def create_issue!(title:, body: nil, labels: [])
    post_body = { title: title }
    post_body[:body] = body if body
    post_body[:labels] = labels if labels

    response = self.class.post(
      "/repos/#{owner}/#{repo}/issues",
      body: post_body.to_json,
      headers: headers
    )

    return response if response.success?

    raise StandardError, "Github API error: #{response['message']}"
  end

  def update_issue!(id, title: nil, body: nil, labels: [])
    post_body = {}
    post_body[:title] = title if title
    post_body[:body] = body if body
    post_body[:labels] = labels if labels.present?

    response = self.class.patch(
      "/repos/#{owner}/#{repo}/issues/#{id}",
      body: post_body.to_json,
      headers: headers
    )

    return response if response.success?

    raise StandardError, "Github API error: #{response['message']}"
  end

  private

  def owner
    ENV.fetch('GITHUB_ORGANIZATION', nil)
  end

  def repo
    ENV.fetch('GITHUB_REPOSITORY', nil)
  end

  def token
    ENV.fetch('GITHUB_AUTHENTICATION_TOKEN', nil)
  end

  def headers
    {
      'User-Agent': repo,
      Accept: 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
      Authorization: "Bearer #{token}"
    }
  end
end
