class MerchantMailer < ApplicationMailer
  def send_new_merchant
    @data = params[:data]
    @proposition_from = params[:proposition_from]

    # Store a TXT copy version of the mail in backup waiting
    # to have a working SMTP configuration.
    EmailAsTextFile.call(
      'merchant_mailer/send_new_merchant',
      data: @data
    )

    mail reply_to: @proposition_from
  end

  def send_report_merchant
    @merchant = params[:merchant].decorate
    @description = params[:description]

    # Store a TXT copy version of the mail in backup waiting
    # to have a working SMTP configuration.
    EmailAsTextFile.call(
      'merchant_mailer/send_report_merchant',
      merchant: @merchant, description: @description
    )

    mail
  end
end
