class AuthenticableErrors < BaseErrors
  UnauthorizedToken = Class.new(self)
  ForbiddenToken = Class.new(self)
end
