module GithubHelper
  def github_api_tag
    @github_api_tag ||= begin
      response = GithubAPI.new.get_last_tag!

      tag_name = response.first['name']
      commit_hash = response.first.dig('commit', 'sha')
      tag_url = "#{github_repository_url}/releases/tag/#{tag_name}"
      commit_url = "#{github_repository_url}/commit/#{commit_hash}"

      {
        tag_name: tag_name,
        commit_hash: commit_hash,
        tag_url: tag_url,
        commit_url: commit_url
      }
    end
  rescue StandardError => e
    { error: true, message: e.message }
  end

  # :nocov:
  # Feature is disabled for now
  def last_short_commit_id
    last_long_commit_id.first(7)
  end

  def last_long_commit_id
    ENV.fetch('GIT_LAST_COMMIT_ID', `git rev-parse HEAD`)
  rescue StandardError
    'Error'
  end

  def deployed_branch
    ENV.fetch('GIT_DEPLOYED_BRANCH', `git branch --show-current`).strip
  rescue StandardError
    'Error'
  end
  # :nocov:
end
