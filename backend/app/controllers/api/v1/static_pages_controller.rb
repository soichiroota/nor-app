module Api
    module V1
        class StaticPagesController < Api::V1::ApplicationController
            def home
                if logged_in?
                    @feed_items = current_user.feed.paginate(page: params[:page])
                    render json: {
                        feed_items: @feed_items.to_json,
                        pages: @feed_items.total_pages,
                        total_feeds: current_user.feed.count
                    }
                else
                    render json: {
                        feed_items: [],
                        pages: 0,
                        total_feeds: 0
                    }
                end
            end
        end
    end
end