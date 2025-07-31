class MerchantMailerPreview < ActionMailer::Preview
  def send_new_merchant
    data = {
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
      description: 'Eos est harum archit',
      coins: MerchantProposal::ALLOWED_COINS,
      website: 'https://mywebsite.com',
      phone: '0102030405',
      contact_session: 'Aut esse quis atque',
      contact_signal: 'Eum lorem ipsum adi',
      contact_matrix: 'Qui et ut neque quis',
      contact_jabber: 'Nisi voluptatem Pos',
      contact_telegram: 'Nemo Nam magna velit',
      contact_facebook: 'Ipsa quisquam iusto',
      contact_instagram: 'Nulla asperiores ali',
      contact_twitter: 'Alias ut ut ipsam om',
      contact_youtube: 'Pariatur Et qui num',
      contact_tiktok: 'Quaerat sit libero ',
      contact_linkedin: 'Unde quae quia quos ',
      contact_tripadvisor: 'Architecto sit simi',
      delivery: '0',
      delivery_zone: 'Consequatur sunt se',
      last_survey_on: '1993-03-16',
      nickname: 'Bot',
      ask_kyc: '1',
      proposition_from: 'johndoe@example.com'
    }.as_json

    MerchantMailer.with(data: data).send_new_merchant
  end

  def send_report_merchant
    @merchant = Merchant.take(5).sample
    @description = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse ut mauris ultricies tellus cursus commodo. Vestibulum condimentum turpis ac justo consectetur, et posuere quam commodo. Nullam nulla enim, hendrerit nec quam eget, volutpat condimentum nibh.'

    MerchantMailer
      .with(merchant: @merchant, description: @description)
      .send_report_merchant
  end
end
