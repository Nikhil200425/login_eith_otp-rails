class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: [:send_otp, :verify_otp]

  def new
    # Step 1: Show email input
    super
  end

  def send_otp
    user = User.find_by(email: params[:user][:email])

    if user
      otp = rand(100000..999999).to_s
      user.update(otp_code: otp, otp_sent_at: Time.current)

      # For testing: show in console
      Rails.logger.info "OTP is: #{otp}"
      OtpMailer.send_otp_email(user, otp).deliver_later
      
      redirect_to otp_verify_path(email: user.email)
    else
      redirect_to new_user_session_path, alert: "Email not found."
    end
  end

  def verify_otp_form
    @user = User.find_by(email: params[:email])
  end

  def verify_otp
    user = User.find_by(email: params[:email])

    if user && user.otp_code == params[:otp] && user.otp_sent_at > 10.minutes.ago
      sign_in(user)
      redirect_to root_path, notice: "Logged in successfully."
    else
      redirect_to otp_verify_path(email: params[:email]), alert: "Invalid or expired OTP."
    end
  end
end