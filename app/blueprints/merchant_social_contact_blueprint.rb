class MerchantSocialContactBlueprint < Blueprinter::Base
  with_options exclude_if_nil: true do
    field :contact_session, name: :session
    field :contact_signal, name: :signal
    field :contact_matrix, name: :matrix
    field :contact_jabber, name: :jabber
    field :contact_telegram, name: :telegram
    field :contact_facebook, name: :facebook
    field :contact_instagram, name: :instagram
    field :contact_twitter, name: :twitter
    field :contact_youtube, name: :youtube
    field :contact_tiktok, name: :tiktok
    field :contact_linkedin, name: :linkedin
    field :contact_tripadvisor, name: :tripadvisor
    field :contact_odysee, name: :odysee
    field :contact_crowdbunker, name: :crowdbunker
    field :contact_francelibretv, name: :francelibretv
  end
end
