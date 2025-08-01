class MerchantMailerPreview < ActionMailer::Preview
  def send_new_merchant
    merchant_proposal = MerchantProposal.new(
      name: 'Carla Wolfe',
      category: 'jewelry',
      # category: 'other',
      # other_category: 'Foobar',
      street: '1 Odit sint',
      postcode: '12345',
      city: 'Foobar',
      country: 'CH',
      latitude: '46.232192999999995',
      longitude: '2.209666999999996',
      description: "Eos est harum archit\nMy second line",
      coins: MerchantProposal::ALLOWED_COINS,
      website: 'https://mywebsite.com',
      phone: '0102030405',
      contact_session: Faker::Internet.url,
      contact_signal: Faker::Internet.url,
      contact_matrix: Faker::Internet.url,
      contact_jabber: Faker::Internet.url,
      contact_telegram: Faker::Internet.url,
      contact_facebook: Faker::Internet.url,
      contact_instagram: Faker::Internet.url,
      contact_twitter: Faker::Internet.url,
      contact_youtube: Faker::Internet.url,
      contact_tiktok: Faker::Internet.url,
      contact_linkedin: Faker::Internet.url,
      contact_tripadvisor: Faker::Internet.url,
      delivery: '1',
      delivery_zone: 'Consequatur sunt se',
      last_survey_on: '1993-03-16',
      nickname: 'Bot',
      ask_kyc: '1',
      proposition_from: 'johndoe@example.com'
    )

    MerchantMailer
      .with(
        data: merchant_proposal.to_osm,
        proposition_from: 'johndoe@example.com'
      )
      .send_new_merchant
  end

  def send_report_merchant
    @merchant = Merchant.take(5).sample
    @description = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse ut mauris ultricies tellus cursus commodo. Vestibulum condimentum turpis ac justo consectetur, et posuere quam commodo. Nullam nulla enim, hendrerit nec quam eget, volutpat condimentum nibh.'

    MerchantMailer
      .with(merchant: @merchant, description: @description)
      .send_report_merchant
  end
end
