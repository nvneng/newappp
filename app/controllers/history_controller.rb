require 'net/http'
require 'json'

class HistoryController < ApplicationController

  def get

    cpage = params['cpage'].to_i
    logger.info params['cpage']
    logger.info cpage
    @records = Srecord.where(:user_id => current_user.id)
    if(@records.count > 0)
      pageCount = @records.count / 10
      pageCount = pageCount.ceil
    else
      pageCount = -1
    end
    logger.info pageCount
    logger.info @records.count
    if(cpage <= pageCount and @records.count > 0)
      @records = @records.reverse_order!
      from_index = cpage*10
      sub_array = @records[from_index , 10]

      history_hash = {'history' => sub_array , 'cpage' => cpage , 'pagecount' => pageCount}



    else
      if(@records.count <= 0)
        history_hash =  {'cpage' => 'nothingtodisplay'}
      end
      history_hash =  {'cpage' => 'nopageleft'}
    end
    render :json => history_hash.to_json
  end

end
