require 'travis/client'

module Travis
  module Client
    module Methods
      def access_token
        session.access_token
      end

      def access_token=(token)
        session.access_token = token
      end

      def api_endpoint
        session.uri
      end

      def github_auth(github_token)
        reply = session.post_raw("/auth/github", :github_token => github_token)
        session.access_token = reply["access_token"]
      end

      def explicit_api_endpoint?
        @explicit_api_endpoint ||= false
      end

      def api_endpoint=(uri)
        @explicit_api_endpoint = true
        session.uri = uri
      end

      def repos(params = {})
        session.find_many(Repository, params)
      end

      def repo(id_or_slug)
        session.find_one(Repository, id_or_slug)
      end

      def worker(id)
        session.find_one(Worker, id)
      end

      def workers(params = {})
        session.find_many(Worker, params)
      end

      def build(id)
        session.find_one(Build, id)
      end

      def job(id)
        session.find_one(Job, id)
      end

      def artifact(id)
        session.find_one(Artifact, id)
      end

      alias log artifact

      def user
        session.find_one(User)
      end

      def restart(entity)
        # btw, internally we call this reset, not restart, as it resets the state machine
        # but we thought that would be too confusing
        session.post_raw('/requests', "#{entity.class.one}_id" => entity.id)
        entity.reload
      end
    end
  end
end