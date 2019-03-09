class OctoClient
  class PrinterNonOperational < StandardError; end
  LOCAL_LULZBOT_URL = 'http://10.0.1.4'
  LOCAL_MAKERGEAR_URL = 'http://10.0.1.12'
  NGROK_LULZBOT_URL = 'http://lulzocto.samdavid.rocks'
  NGROK_MAKERGEAR_URL = 'http://makerocto.samdavid.rocks'

  attr_reader :printer, :headers

  def initialize(printer)
    @printer = printer
    initialize_headers
  end

  def initialize_headers
    api_key = if @printer == 'lulzbot'
                ENV['OCTOPI_LULZBOT_API_KEY']
              elsif @printer == 'makergear'
                ENV['OCTOPI_MAKERGEAR_API_KEY']
              end

    @headers = {
      'X-Api-Key' => api_key
    }
  end

  def info
    octo_get('printer')
  end

  def files
    octo_get('files')
  end

  def job
    octo_get('job')
  end

  def logs
    octo_get('logs')
  end

  def file_info(filename)
    octo_get("files/local/#{filename}")
  end

  def post_file_command
    octo_post("files/local/#{filename}", {
      command: 'select',
      print: true
    })
  end

  def post_tool_command(command, payload)
    payload = { command: command }.merge(payload)
    response = octo_post("printer/tool", payload)
  end

  def post_printer_tool_temp(temp)
    response = octo_post("printer/tool", {
      command: 'target',
      targets: {
        tool0: temp.to_i
      }
    })

    byebug
  end


  def post_home_command(axes)
    octo_post("printer/printhead", {
      command: 'home',
      axes: axes
    })
  end

  def post_jog_command(x, y, z)
    octo_post("printer/printhead", {
      command: 'jog',
      x: x,
      y: y,
      z: z
    })
  end

  # http://docs.octoprint.org/en/master/api/connection.html#issue-a-connection-command
  def post_connection
    octo_post("connection", {
      command: 'select',
    })
  end

  def delete_file(filename)
    octo_delete(File.join('files', 'local', filename))
  end

  def octo_get(url)
    response = HTTParty.get(octo_url(url), headers: @headers)
    raise PrinterNonOperational if response == "Printer is not operational"

    response
  end

  def octo_delete(url)
  end

  def octo_post(url, payload)
    HTTParty.post(octo_url(url), body: payload.to_json)
  end

  def octo_post(url, payload)
    url = URI(octo_url(url))

    http = Net::HTTP.new(url.host, url.port)

    request = Net::HTTP::Post.new(url)
    request["X-Api-Key"] = '25BF160035354521978E60B57E7F18C6'
    request["Content-Type"] = 'application/json'
    request["Cache-Control"] = 'no-cache'
    # request.body = {
    #   command: 'home',
    #   axes: %w[x y]
    # }.to_json
    request.body = payload.to_json
    #request.body = "{\n\t\"command\": \"target\",\n\t\"targets\": {\n\t\t\"tool0\": #{temp}\n\t}\n}"

    response = http.request(request)

    byebug

    response
  end

  def octo_url(url)
    File.join(octo_base_url, '/api/', url)
  end

  def octo_base_url
    if Rails.env.production?
      case @printer
      when 'lulzbot'
        NGROK_LULZBOT_URL
      when 'makergear'
        NGROK_MAKERGEAR_URL
      end
    else
      case @printer
      when 'lulzbot'
        LOCAL_LULZBOT_URL
      when 'makergear'
        LOCAL_MAKERGEAR_URL
      end
    end
  end
end


