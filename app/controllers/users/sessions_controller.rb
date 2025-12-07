# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  # Optional: skip Devise's default params sanitizer if you want custom param handling
  # skip_before_action :verify_signed_out_user, only: :destroy

  # Render login form (Devise does this automatically if you generate views)
  def new
    super
  end

  # Custom create action — we control auth, locking/throttle, and redirect
  def create
    email = params[:user][:email]
    password = params[:user][:password]

    user = User.find_by(email: email)

    if user && user.valid_password?(password)
      # custom role-based logic
      sign_in(:user, user)

      flash[:notice] = "Signed in successfully!"

      # redirect based on role
      if user.role == "admin"
        redirect_to hospitals_path and return
      else
        redirect_to appointments_path and return
      end

    else
      flash.now[:alert] = "Invalid email or password"

      # IMPORTANT — Do NOT use respond_with_navigational (it causes users_url error)
      render :new, status: :unauthorized
    end
  end

  # Custom destroy (sign out) — call Devise's sign_out helper then redirect
  def destroy
    sign_out(current_user) if current_user
    flash[:notice] = "Signed out successfully."
    redirect_to root_path
  end

  private

  # If you want to reuse Devise's resource_name and resource helpers in view:
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end
end
