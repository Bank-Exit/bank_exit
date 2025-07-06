module SEOHelper
  def seo_meta_tags(pagy)
    display_meta_tags site: I18n.t('seo.default.title'),
                      title: title_for_page,
                      description: description_for_page,
                      reverse: true,
                      charset: 'utf-8',
                      lang: I18n.locale,
                      prev: pagy ? pagy_prev_url(pagy) : nil,
                      next: pagy ? pagy_next_url(pagy) : nil,
                      og: {
                        title: :title,
                        site_name: :site,
                        description: :description,
                        image: asset_url(logo_by_locale),
                        url: request.url
                      },
                      twitter: {
                        card: 'summary',
                        site: '@SortieDeBanque',
                        title: :title,
                        description: :description,
                        image: asset_url(logo_by_locale),
                        url: request.url
                      },
                      icon: [
                        { href: image_path(logo_by_locale), type: 'image/png' }
                      ],
                      viewport: 'width=device-width,initial-scale=1',
                      'turbo-cache-control': 'no-preview',
                      'view-transition': 'same-origin',
                      'turbo-refresh-method': 'morph',
                      'turbo-refresh-scroll': 'scroll',
                      'apple-mobile-web-app-capable': 'yes',
                      'mobile-web-app-capable': 'yes'
  end

  def schema_dot_org_organization
    JSON.pretty_generate(
      '@context': 'http://schema.org/',
      '@type': 'Organization',
      name: 'Collectif Sortie de Banque',
      url: root_url,
      logo: asset_url(logo_by_locale),
      founder: {
        '@type': 'Person',
        name: 'Pierre'
      },
      foundingDate: Date.new(2002, 1, 1),
      sameAs: [
        'https://x.com/SortieDeBanque',
        'https://x.com/Bank_Exit',
        'https://www.youtube.com/@sortiedebanque',
        'http://t.me/SortieDeBanque',
        'https://odysee.com/@SortieDeBanque:c',
        'https://www.instagram.com/sortiedebanque/',
        'https://www.tiktok.com/@sortiedebanque',
        'https://facebook.com/sortiedebanque'
      ]
    )
  end

  def schema_dot_org_breadcrumb_blog(blog)
    json = {
      '@context': 'https://schema.org',
      '@type': 'BreadcrumbList',
      itemListElement: [
        {
          '@type': 'ListItem',
          position: 1,
          item: {
            name: I18n.t('application.nav.menu.home'),
            url: root_url
          }
        },
        {
          '@type': 'ListItem',
          position: 2,
          item: {
            name: I18n.t('application.nav.menu.blogs'),
            url: blogs_url
          }
        },
        {
          '@type': 'ListItem',
          position: 3,
          item: {
            name: blog.title,
            url: blog_url(blog)
          }
        }
      ]
    }

    JSON.pretty_generate(json)
  end

  def schema_dot_org_breadcrumb_tutorial(tutorial)
    json = {
      '@context': 'https://schema.org',
      '@type': 'BreadcrumbList',
      itemListElement: [
        {
          '@type': 'ListItem',
          position: 1,
          item: {
            name: I18n.t('application.nav.menu.home'),
            url: root_url
          }
        },
        {
          '@type': 'ListItem',
          position: 2,
          item: {
            name: I18n.t('application.nav.menu.tutorials'),
            url: tutorials_url
          }
        },
        {
          '@type': 'ListItem',
          position: 3,
          item: {
            name: tutorial.title,
            url: tutorial_url(tutorial)
          }
        }
      ]
    }

    JSON.pretty_generate(json)
  end

  def schema_dot_org_blog(blog)
    json = {
      '@context': 'http://schema.org/',
      '@type': 'BlogPosting',
      name: blog.title,
      datePublished: blog.created_at,
      url: blog_url(blog)
    }

    json[:description] = blog.short_description if blog.short_description

    json[:articleBody] = []
    blog.all_body.each do |body|
      json[:articleBody] << strip_tags(body)
    end

    if blog.video?
      json[:video] = {
        '@type': 'VideoObject',
        name: blog.video.title,
        embedUrl: blog.video.url
      }
    end

    JSON.pretty_generate(json)
  end

  def schema_dot_org_tutorial(tutorial)
    json = {
      '@context': 'http://schema.org/',
      '@type': 'TechArticle',
      name: tutorial.title,
      license: license_url,
      proficiencyLevel: tutorial.level
    }

    json[:articleBody] = []
    tutorial.all_body.each do |body|
      json[:articleBody] << strip_tags(body)
    end

    if tutorial.video?
      json[:video] = {
        '@type': 'VideoObject',
        name: tutorial.video.title,
        embedUrl: tutorial.video.url
      }
    end

    JSON.pretty_generate(json)
  end

  def schema_dot_org_merchant(merchant)
    json = {
      '@context': 'http://schema.org/',
      '@type': FindSchemaOrgType.call(merchant.category),
      name: merchant.name,
      paymentAccepted: 'Cryptocurrency',
      currenciesAccepted: merchant.ticker_coins.join(', ')
    }

    json[:email] = merchant.email if merchant.email?
    json[:url] = merchant.website if merchant.website?
    json[:telephone] = merchant.phone if merchant.phone?
    json[:description] = merchant.description if merchant.description?

    json[:logo] = image_url(url_for(merchant.logo)) if merchant.logo.attached?
    json[:photo] = image_url(url_for(merchant.banner)) if merchant.banner.attached?

    json[:sameAs] = merchant.all_links if merchant.all_links.any?

    json[:openingHours] = merchant.opening_hours if merchant.opening_hours.present?

    json[:latitude] = merchant.latitude
    json[:longitude] = merchant.longitude

    if merchant.address?
      json[:address] = { '@type': 'PostalAddress' }
      json[:address][:streetAddress] = "#{merchant.house_number} #{merchant.street}" if merchant.street
      json[:address][:postalCode] = merchant.postcode if merchant.postcode
      json[:address][:addressLocality] = merchant.city if merchant.city
      json[:address][:addressCountry] = merchant.country if merchant.country
    end

    if comments_enabled? && merchant.comments_count.positive?
      json[:aggregateRating] = {
        '@type': 'AggregateRating',
        ratingValue: merchant.average_rating,
        reviewCount: merchant.comments_count
      }

      json[:review] = []

      merchant.comments.each do |comment|
        json[:review] << {
          '@type': 'Review',
          author: {
            '@type': 'Person',
            name: comment.pseudonym || 'John Doe'
          },
          discussionUrl: polymorphic_url(comment.commentable),
          datePublished: comment.created_at.to_date,
          reviewBody: comment.content,
          reviewRating: {
            '@type': 'Rating',
            bestRating: merchant.comments.maximum(:rating),
            ratingValue: comment.rating,
            worstRating: merchant.comments.minimum(:rating)
          }
        }
      end
    end

    JSON.pretty_generate(json)
  end

  def schema_dot_org_directory(directory)
    json = {
      '@context': 'http://schema.org/',
      '@type': FindSchemaOrgType.call(directory.category),
      name: directory.name
    }

    coin_wallets = directory.coin_wallets.enabled
    contact_ways = directory.contact_ways.enabled

    json[:acceptedPaymentMethod] = coin_wallets.map(&:coin).join(', ') if coin_wallets.any?

    if contact_ways.any?
      json[:sameAs] = []
      contact_ways.each do |contact|
        json[:sameAs] << contact.value
      end
    end

    JSON.pretty_generate(json)
  end

  def schema_dot_org_faq(faqs)
    json = {
      '@context': 'http://schema.org/',
      '@type': 'FAQPage',
      name: I18n.t('faqs.show.title'),
      mainEntity: []
    }

    faqs.each do |faq|
      text = []
      faq.content.each do |paragraph|
        answer = paragraph['answer']
        if answer.is_a?(String)
          text << answer
        elsif answer.is_a?(Array)
          text << answer.join(' ')
        end
      end

      json[:mainEntity] << {
        '@type': 'Question',
        name: faq.question,
        acceptedAnswer: {
          '@type': 'Answer',
          text: text.join(' ')
        }
      }
    end

    JSON.pretty_generate(json)
  end

  private

  def title_for_page
    content_for(:title) ||
      t('title', scope: [controller_name, action_name], default: default_title)
  end

  def description_for_page
    desc = t('description', scope: [controller_name, action_name], default: '')

    return desc.truncate(150) unless desc.empty?

    desc_html = t('description_html', scope: [controller_name, action_name], default: '')

    if desc_html.present?
      strip_tags(desc_html).truncate(150)
    else
      default_description.truncate(150)
    end
  end

  def default_title
    t('seo.default.title')
  end

  def default_description
    t('seo.default.description')
  end
end
