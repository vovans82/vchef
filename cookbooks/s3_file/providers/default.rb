require 'rest-client'
require 'time'
require 'openssl'
require 'base64'

action :create do
  body = get_from_s3(@new_resource.bucket, @new_resource.remote_path, @new_resource.aws_access_key_id, @new_resource.aws_secret_access_key).body
  file @new_resource.path do
    action :create
    content body
  end
end

def get_from_s3(bucket,path,aws_access_key_id,aws_secret_access_key)
	now = Time.now().utc.strftime('%a, %d %b %Y %H:%M:%S GMT')
	string_to_sign = "GET\n\n\n%s\n/%s%s" % [now,bucket,path]
		
	digest = digest = OpenSSL::Digest::Digest.new('sha1')
	signed = OpenSSL::HMAC.digest(digest, aws_secret_access_key, string_to_sign)
	signed_base64 = Base64.encode64(signed)
	
	auth_string = 'AWS %s:%s' % [aws_access_key_id,signed_base64]
		
	response = RestClient.get('https://%s.s3.amazonaws.com%s' % [bucket,path], :date => now, :authorization => auth_string)
	
	return response.body	
end

