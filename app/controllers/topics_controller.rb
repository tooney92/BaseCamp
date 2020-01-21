class TopicsController < ApplicationController
    def create
        render plain: "hello topic page"
    end


    def private
        def thread_params
            params.require(:topic).permit(:topic)
        end
    end

end
