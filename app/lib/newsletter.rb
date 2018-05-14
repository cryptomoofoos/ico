class Newsletter
  def self.subscribe(email)
    return true if Rails.env.development?
    raise "Empty List ID" if ENV['ML_LIST'].blank?
    raise "Empty email address" if email.blank?

    begin
      mailchimp = Mailchimp::API.new( ENV['ML_KEY'] )
      mailchimp.lists.subscribe(ENV['ML_LIST'], {email: email}, {}, 'html', false)
    rescue => e
      Rails.logger.warn "Subscription failed for #{email}: #{e}"
    end
  end
end
