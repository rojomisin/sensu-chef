def get_secret_from_url(path)
  require 'uri'
  uri = URI(path)
  case uri.scheme
    when 's3' then
      return `python -c 'import boto; conn = boto.connect_s3(); bucket = conn.get_bucket("#{uri.host}"); key = bucket.get_key("#{uri.path}"); print key.get_contents_as_string()'`.chomp
    when 'file' then
      return Chef::EncryptedDataBagItem.load_secret(uri.path)
  end
  fail 'Invalid scheme for secret path.'
end
