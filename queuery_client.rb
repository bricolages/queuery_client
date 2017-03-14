require 'uri'
require 'net/http'

class QueueryClient
  class << self
    attr_accessor :host
    attr_accessor :port

    def query(select_stmt)
      client = new(
        host: host,
        port: port,
      )

      res = client.query_and_wait(select_stmt)
      RedshiftConnector::UrlDataFileBundle.new(res['data_objects'])
    end
  end

  def initialize(host:, port: 80)
    @host = host
    @port = port
  end

  def request(req)
    res = Net::HTTP.new(@host, @port).request(req)
    JSON.parse(res.body)
  end

  def request_post(path, params = {})
    post_req = Net::HTTP::Post.new(path)
    post_req.form_data = params
    request(post_req)
  end

  def request_get(path)
    get_req = Net::HTTP::Get.new(path)
    request(get_req)
  end

  def query(select_stmt)
    request_post('/queries', { q: select_stmt })
  end

  def status(job_id)
    request_get("/queries/#{job_id}")
  end

  def wait_for(job_id)
    loop do
      res = status(job_id)
      case res['status']
      when 'success', 'failed'
        return res
      end
      sleep 1
    end
  end

  def query_and_wait(select_stmt)
    res = query(select_stmt)
    wait_for(res['job_id'])
  end
end
