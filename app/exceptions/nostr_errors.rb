class NostrErrors < BaseErrors
  MissingPrivateKey = Class.new(self)
  MissingRelayUrl = Class.new(self)
end
