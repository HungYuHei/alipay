module Alipay
  module Notify
    module Wap
      #for call_back_url return
      def self.verify_sign_only?(params)
        params = Utils.stringify_keys(params)
        Sign::Wap.verify?(params)
      end

      #for notify_url return
      def self.verify?(params)
        params = Utils.stringify_keys(params)

        data = params['notify_data']
        notify_id = $~[1] if data =~ /<notify_id>(.*?)<\/notify_id>/

        Sign::Wap.verify?(params) && Notify.verify_notify_id?(notify_id)
      end
    end

    def self.verify?(params)
      params = Utils.stringify_keys(params)
      Sign.verify?(params) && verify_notify_id?(params['notify_id'])
    end

    private

    def self.verify_notify_id?(notify_id)
      open("https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{Alipay.pid}&notify_id=#{CGI.escape notify_id.to_s}").read == 'true'
    end
  end
end
