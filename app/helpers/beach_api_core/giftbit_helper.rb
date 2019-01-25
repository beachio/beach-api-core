module BeachApiCore
  module GiftbitHelper
    class << self
      GIFTBIT_API = ENV['USE_TESTBET'] == 'true' ? "https://api-testbed.giftbit.com/papi/v1" : "https://api.giftbit.com/papi/v1"
      def get_current_balance(api_key)
        api = "#{GIFTBIT_API}/funds"
        uri = URI.parse(api)
        req = Net::HTTP::Get.new(uri)
        req['Authorization'] = "Bearer #{api_key}"
        res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
          http.request(req)
        }
        body = JSON.parse(res.body)
        body['fundsbycurrency']['USD']['available_in_cents']
      end

      def get_brand_amounts(api_key, brand_code)
        uri = URI.parse("#{GIFTBIT_API}/brands/#{brand_code}")
        req = Net::HTTP::Get.new(uri)
        req['Authorization'] = "Bearer #{api_key}"
        res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
          http.request(req)
        }
        body = JSON.parse(res.body)
        body["error"].nil? ? body['brand'] : []
      end

      def check_token(api_key)
        uri = URI.parse("#{GIFTBIT_API}/ping")
        req = Net::HTTP::Get.new(uri)
        req['Authorization'] = "Bearer #{api_key}"
        res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) {|http|
          http.request(req)
        }
        JSON.parse(res.body)
      end

      def create_campaign(api_key, contacts, links_count, id, cost, brand_code, expired_at, deliver_by_email, mail_conf)
        deliver_by_email = deliver_by_email ? "GIFTBIT_EMAIL" : "SHORTLINK"
        expired_at = expired_at.zero? ? Time.now + 1.year : Time.now + expired_at.to_i.day
        template_id = mail_conf[:email_template].blank? ? nil : mail_conf[:email_template]
        api = "#{GIFTBIT_API}/campaign"
        uri = URI.parse(api)
        req = Net::HTTP::Post.new(uri)
        req['Content-Type'] = 'application/json'
        req['Authorization'] = "Bearer #{api_key}"
        body = create_campaign_body(template_id, deliver_by_email, cost, brand_code, contacts, links_count, expired_at, id)

        if template_id.nil?
          response = create_campaign_without_template(uri, req, body, mail_conf)
        else
          res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
            req.body = body.to_json
            http.request(req)
          end
          response = JSON.parse(res.body)
          response = create_campaign_without_template(uri, req, body, mail_conf) if response['error'] && response['error']['name'] == 'Invalid template id'
        end
        response
      end

      def create_campaign_without_template(uri, req, body, mail_config)
        body.delete(:gift_template)
        if mail_config && !(mail_config[:email_subject].nil? || mail_config[:email_subject].empty? )
          body[:subject] = mail_config[:email_subject]
          body[:message] = mail_config[:email_body].nil? || mail_config[:email_body].empty? ? "New gift was received" : mail_config[:email_body].gsub("\n", "<br>")
        else
          body[:subject] = "Your Reward"
          body[:message] = "Congrats Partner, <br>
You're no longer a Rookie. <br>
You've done enough over the past weeks that I'm proud to send you this reward.<br>

Laters Amigo.<br>
"
        end
        res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          req.body = body.to_json
          http.request(req)
        end
        JSON.parse(res.body)
      end

      def get_gifts(api_key, email = nil, uuid = nil)
        result = api_request(api_key, Net::HTTP::Get, uuid, email, true)
        if result['gifts'].blank?
          []
        else
          gifts = {email_mode: true}
          if result['gifts'][0]['shortlink'].nil?
            gifts[:emails] = {}
            result['gifts'].each do |gift|
              gifts[:emails][gift["recipient_email"]].blank? ? gifts[:emails][gift["recipient_email"]] = [{uuid: gift["uuid"]}]  : gifts[:emails][gift["recipient_email"]] <<  {uuid: gift["uuid"]}
            end
          else
            gifts[:email_mode] = false
            gifts[:shortlinks] = result['gifts'].map {|gift| [gift['shortlink'], gift['uuid']]}
          end
          gifts
        end
      end

      def resend_gift api_key, uuid
        @body = { resend: true }.to_json
        api_request(api_key, Net::HTTP::Put, uuid)
      end

      def cancel_gift api_key, uuid
        api_request(api_key, Net::HTTP::Delete, uuid)
      end

      def gift_status api_key, uuid
        @body = nil
        response = api_request(api_key, Net::HTTP::Get, uuid)
        response['gift']['status']
      end

      private

      def api_request api_key, method, uuid=nil, email=nil, gifts=false
        api = "#{GIFTBIT_API}/gifts"
        api += uuid.nil? ? "?recipient_email=#{email}" : "?campaign_uuid=#{uuid}" if gifts
        api += "/#{uuid}" unless gifts
        uri = URI.parse(api)
        req = method.new(uri)
        req['Content-Type'] = 'application/json'
        req['Authorization'] = "Bearer #{api_key}"
        res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          req.body = @body
          http.request(req)
        end
        JSON.parse(res.body)
      end

      def create_campaign_body template_id, deliver_by_email, cost, brand_code, contacts = nil, link_count = nil, expired_at, id
        body = {
            gift_template: template_id,
            delivery_type: deliver_by_email,
            price_in_cents: cost,
            brand_codes: [brand_code],
            expiry: expired_at,
            id: id
        }
        unless contacts.nil?
          body['contacts'] = contacts
        else
          body['link_count'] = link_count
        end
        body
      end
    end
  end
end
