module MyApi
  class ApiController < ActionController::Base
    before_filter :auth_api

    def status
      render json: {"ok" => true}
    end

    # Don't trust discourse's github user name...
    def user
      user = nil

      if user.nil? && email = params[:email]
        user = User.find_by(email: email)
      end

      if user.nil? && github_id = params[:github_id]
        github_id = github_id.downcase
        # FIXME: discourse for some reason translates - to "_" when storing github user info
        github_id = github_id.tr("-","_")
        # try look up by replacing - with "_" as well...
        ginfo = GithubUserInfo.where("lower(screen_name) = ?",github_id).first
        if ginfo
          user = ginfo.user
        end
      end

      if user.nil?
        json = {
          "error" => "user not found"
        }
        render(json: json, status:404)
      else
        json = {
          "discourse_username" => user.username,
          "email" => user.email
        }
        render(json: json)
      end
    end

    private

    def auth_api
      if !is_root_api?
        err = {
          "error" => "invalid api key"
        }
        render(json: err, status: 403)
      end
    end

    def is_root_api?
      if api_key
        key = ApiKey.find_by(key: api_key)
        key && key.user_id.nil?
      else
        false
      end
    end

    def api_key
      @api_key ||= request["api_key"] || request.headers["Api-Key"]
    end
  end
end
