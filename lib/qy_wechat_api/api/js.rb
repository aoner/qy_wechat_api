module QyWechatApi
  module Api
    class Js < Base
      def sign_package(url)
        timestamp = Time.now.to_i
        noncestr  = SecureRandom.hex(16)
        str = "jsapi_ticket=#{get_jsticket}&noncestr=#{noncestr}&timestamp=#{timestamp}&url=#{url}";
        signature = Digest::SHA1.hexdigest(str)
        {
          "appId"     => corp_id,    "nonceStr"  => noncestr,
          "timestamp" => timestamp, "url"       => url,
          "signature" => signature, "rawString" => str
        }
      end
      
      def yy_sign_package(url)
        timestamp = Time.now.to_i
        noncestr  = SecureRandom.hex(16)
        str = "jsapi_ticket=#{get_js_ticket}&noncestr=#{noncestr}&timestamp=#{timestamp}&url=#{url}";
        signature = Digest::SHA1.hexdigest(str)
        {
          "appId"     => corp_id,    "nonceStr"  => noncestr,
          "timestamp" => timestamp, "url"       => url,
          "signature" => signature, "rawString" => str
        }
      end

      # https://qyapi.weixin.qq.com/cgi-bin/get_jsapi_ticket?access_token=ACCESS_TOKE
      def get_jsticket
        cache_key = "jsticket-#{corp_id}"
        QyWechatApi.cache.fetch(cache_key, expires_in: 7100.seconds) do
          res = http_get("/get_jsapi_ticket", {waive_base_url: true})
          ticket = res.result["ticket"]
          if ticket.blank?
            QyWechatApi.cache.delete(cache_key)
            raise res.errors
          else
            ticket
          end
        end
      end
      
      # https://qyapi.weixin.qq.com/cgi-bin/ticket/get?access_token=ACCESS_TOKEN&type=agent_config
      def get_js_ticket
        cache_key = "js_ticket-#{corp_id}"
        QyWechatApi.cache.fetch(cache_key, expires_in: 7100.seconds) do
          res = http_get("/ticket/get", {type: 'agent_config'})
          ticket = res.result["ticket"]
          if ticket.blank?
            QyWechatApi.cache.delete(cache_key)
            raise res.errors
          else
            ticket
          end
        end
      end

    end
  end
end
