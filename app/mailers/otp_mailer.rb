class OtpMailer < ApplicationMailer
    default from: 'no-reply@gmail.com'
    def send_otp_email(user, otp)
        @otp = otp
        @user = user
        mail(to: @user.email, subject: 'Your OTP code:' )
    end
end
