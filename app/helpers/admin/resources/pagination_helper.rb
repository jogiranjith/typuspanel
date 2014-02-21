module Admin::Resources::PaginationHelper

  def admin_paginate
    params[:per_page] ||= @resource.typus_options_for(:per_page)
    params[:per_page] = params[:per_page].to_i

    params[:offset] ||= 0
    params[:offset] = params[:offset].to_i

    next_offset = params[:offset] + params[:per_page]
    previous_offset = params[:offset] - params[:per_page]

    options = {}

    current_page = (params[:offset].to_f / params[:per_page]) + 1
    num_pages = (@resource.count.to_f / params[:per_page]).ceil
    unless current_page >= num_pages
      options[:next] = params.merge(offset: next_offset)
    end

    if previous_offset >= 0
      options[:previous] = params.merge(offset: previous_offset)
    end

    render "admin/resources/pagination", { :options => options }
  end

end
