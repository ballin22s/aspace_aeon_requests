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

  # generate aeon request url:
  # [title, site, callnum, sublocation, itemvolume]
  def build_aeon_request_url
    # hash for params required for aeon extracted from @request
    callnum = id_to_callnum
    site    = site_lookup
    title   = title_with_hierarchy

    params = {
      callnum: callnum,
      site:    site,
      title:   title,
    }
    params[:itemvolume]  = container_to_itemvolume if @request.container
    params[:sublocation] = location_to_sublocation if @request.location_title

    URI::HTTPS.build(host: @endpoint, path: '/OpenURL', query: URI.encode_www_form(params))
  end

  def container_to_itemvolume
    barcode    = @request.barcode ? @request.barcode.shift : nil
    itemvolume = @request.container ? @request.container.shift : nil
    itemvolume = itemvolume.concat(", Barcode: #{barcode}") if barcode and itemvolume
    itemvolume
  end

  def id_to_callnum
    @request.resource_id ? @request.resource_id : @request.identifier
  end

  def location_to_sublocation
    @request.location_title ? @request.location_title.shift : nil
  end

  def site_lookup
    site = AppConfig[:aspace_aeon_requests_repo_map].fetch(
      @request.repo_code,
      AppConfig[:aspace_aeon_requests_repo_default]
    )
    site = @request.repo_code unless site
    site
  end

  def title_with_hierarchy
    @request.hierarchy ? @request.hierarchy.push(@request.title).join(",") : @request.title
  end

end
