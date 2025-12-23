class JsonWebToken
  SECRET_KEY = Rails.application.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decode = JWT.decode(token, SECRET_KEY)
    HashWithIndifferentAccess.new(decode[0])
  rescue JWT::ExpiredSignature, JWT::DecodeError
    nil
  end
end