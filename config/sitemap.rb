options = {
  default_host: 'https://bank-exit.org',
  include_root: false
}

SitemapGenerator::Sitemap.create(**options) do
  I18n.available_locales.each do |locale|
    I18n.with_locale(locale) do
      group(filename: "sitemap.#{locale}") do
        add root_path, priority: 1, alternates: (I18n.available_locales.map do |locale|
          {
            href: root_url(locale: locale.to_s, host: options[:default_host]),
            lang: locale.to_s
          }
        end)

        add maps_path, changefreq: 'daily', priority: 1, alternates: (I18n.available_locales.map do |locale|
          {
            href: maps_url(locale: locale.to_s, host: options[:default_host]),
            lang: locale.to_s
          }
        end)

        add faq_path, alternates: (I18n.available_locales.map do |locale|
          {
            href: faq_url(locale: locale.to_s, host: options[:default_host]),
            lang: locale.to_s
          }
        end)

        add risks_path, alternates: (I18n.available_locales.map do |locale|
          {
            href: risks_url(locale: locale.to_s, host: options[:default_host]),
            lang: locale.to_s
          }
        end)

        add media_path, alternates: (I18n.available_locales.map do |locale|
          {
            href: media_url(locale: locale.to_s, host: options[:default_host]),
            lang: locale.to_s
          }
        end)

        add local_groups_path, alternates: (I18n.available_locales.map do |locale|
          {
            href: local_groups_url(locale: locale.to_s, host: options[:default_host]),
            lang: locale.to_s
          }
        end)

        add collective_path, alternates: (I18n.available_locales.map do |locale|
          {
            href: collective_url(locale: locale.to_s, host: options[:default_host]),
            lang: locale.to_s
          }
        end)

        add statistics_path, changefreq: 'daily', alternates: (I18n.available_locales.map do |locale|
          {
            href: statistics_url(locale: locale.to_s, host: options[:default_host]),
            lang: locale.to_s
          }
        end)

        add glossaries_path, alternates: (I18n.available_locales.map do |locale|
          {
            href: glossaries_url(locale: locale.to_s, host: options[:default_host]),
            lang: locale.to_s
          }
        end)

        add new_merchant_proposal_path, alternates: (I18n.available_locales.map do |locale|
          {
            href: new_merchant_proposal_url(locale: locale.to_s, host: options[:default_host]),
            lang: locale.to_s
          }
        end)

        Merchant.available.find_each do |merchant|
          add merchant_path(merchant), alternates: (I18n.available_locales.map do |locale|
            {
              href: merchant_url(merchant, locale: locale.to_s, host: options[:default_host]),
              lang: locale.to_s
            }
          end)
        end

        add directories_path, priority: 1, alternates: (I18n.available_locales.map do |locale|
          {
            href: directories_url(locale: locale.to_s, host: options[:default_host]),
            lang: locale.to_s
          }
        end)

        add new_directory_path, changefreq: 'yearly', alternates: (I18n.available_locales.map do |locale|
          {
            href: new_directory_url(locale: locale.to_s, host: options[:default_host]),
            lang: locale.to_s
          }
        end)

        Directory.enabled.find_each do |directory|
          add directory_path(directory), alternates: (I18n.available_locales.map do |locale|
            {
              href: directory_url(directory, locale: locale.to_s, host: options[:default_host]),
              lang: locale.to_s
            }
          end)
        end

        projects = Project.all
        projects.each do |project|
          next if project.identifier == 'map'

          add project_path(project.identifier), alternates: (I18n.available_locales.map do |locale|
            {
              href: project_url(project.identifier, locale: locale.to_s, host: options[:default_host]),
              lang: locale.to_s
            }
          end)
        end

        add blogs_path, alternates: (I18n.available_locales.map do |locale|
          {
            href: blogs_url(locale: locale.to_s, host: options[:default_host]),
            lang: locale.to_s
          }
        end)

        blogs = Blog.all
        blogs.each do |blog|
          add blog_path(blog.identifier), alternates: (I18n.available_locales.map do |locale|
            {
              href: blog_url(blog.identifier, locale: locale.to_s, host: options[:default_host]),
              lang: locale.to_s
            }
          end)
        end

        add tutorials_path, alternates: (I18n.available_locales.map do |locale|
          {
            href: tutorials_url(locale: locale.to_s, host: options[:default_host]),
            lang: locale.to_s
          }
        end)

        tutorials = Tutorial.all
        tutorials.each do |tutorial|
          add tutorial_path(tutorial.identifier), alternates: (I18n.available_locales.map do |locale|
            {
              href: tutorial_url(tutorial.identifier, locale: locale.to_s, host: options[:default_host]),
              lang: locale.to_s
            }
          end)
        end
      end
    end
  end
end
