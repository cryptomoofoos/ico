module ApplicationHelper
  def whitepaper_path(locale = :en)
    default = "/docs/lwf_whitepaper_en.pdf"
    path = "/docs/lwf_whitepaper_#{locale}.pdf"
    File.exists?(File.join('public', path)) ? path : default
  end
end
