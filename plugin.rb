# name: login-required-param
# about:  Force login_required on some User Agent.
# version: 0.1
# authors: zh99998 <zh99998@gmail.com>

after_initialize do
  ApplicationController.class_eval do
    def redirect_to_login_if_required
      return if current_user || (request.format.json? && is_api?)

      if SiteSetting.login_required? || params[:login_required]
        flash.keep

        if SiteSetting.enable_sso?
          # save original URL in a session so we can redirect after login
          session[:destination_url] = destination_url
          redirect_to path('/session/sso')
        elsif params[:authComplete].present?
          redirect_to path("/login?authComplete=true")
        else
          # save original URL in a cookie (javascript redirects after login in this case)
          cookies[:destination_url] = destination_url
          redirect_to path("/login")
        end
      end
    end
  end
end
