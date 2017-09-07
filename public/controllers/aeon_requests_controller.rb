require Rails.root.join('app', 'controllers', 'requests_controller')

# override public RequestsController
class RequestsController < ApplicationController

  # override make_request: redirect the request to aeon
  def make_request
    @request  = RequestItem.new(params)
    @endpoint = AppConfig[:aspace_aeon_requests_endpoint]

    # @request contains all available request data (see README.md for examples)
    $stdout.puts("\n\n\n#{@request.to_h}\n\n\n")

    errs = @request.validate
    if errs.blank?
      # TODO: redirect_to build_aeon_request_url
      flash[:notice] = build_aeon_request_url.to_s
      $stdout.puts("\n\n\n#{build_aeon_request_url.to_s}\n\n\n")
      redirect_to params.fetch('base_url', request[:request_uri])
    else
      flash[:error] = errs
      redirect_back(fallback_location: request[:request_uri]) and return
    end
  end

  private

  # generate aeon request url: [title, site, callnum, sub_location, item_volume]
  def build_aeon_request_url
    # hash for params required for aeon extracted from @request
    # TODO: move to config?
    callnum = @request.resource_id ? @request.resource_id : @request.identifier
    params  = {
      title:   @request.title,
      site:    @request.repo_code,
      callnum: callnum,
    }

    if @request.location_title
      # TODO: parse and add to params
      # params[:sub_location] = 
      # params[:item_volume]  =
    end
    
    URI::HTTPS.build(host: @endpoint, path: '/OpenURL', query: URI.encode_www_form(params))
  end

end
