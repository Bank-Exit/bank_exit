module CryptoPatterns
  BITCOIN_ADDRESS_REGEX   = /\A(bc1|1|3)[a-zA-HJ-NP-Z0-9]{25,39}\z/
  LIGHTNING_INVOICE_REGEX = /\Alnbc[0-9a-zA-Z]{10,}\z/
  MONERO_ADDRESS_REGEX    = /\A(4[1-9A-HJ-NP-Za-km-z]{94}|4[1-9A-HJ-NP-Za-km-z]{105}|8[1-9A-HJ-NP-Za-km-z]{94})\z/
  JUNE_KEY_REGEX          = /\A[A-Za-z0-9]{42,55}\z/

  def self.detect_type(value)
    case value
    when BITCOIN_ADDRESS_REGEX
      :bitcoin
    when LIGHTNING_INVOICE_REGEX
      :lightning
    when MONERO_ADDRESS_REGEX
      :monero
    when JUNE_KEY_REGEX
      :june
    end
  end
end
