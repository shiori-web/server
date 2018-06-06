class UserMailer < ApplicationMailer
  default from: 'no-reply@shiori.com'

  def confirm_email
    @user = User.find(params[:user_id])
    @redirect_url = params[:redirect_url]
    mail to: @user.email, subject: I18n.t('emails.users.confirm.subject')
  end
end
