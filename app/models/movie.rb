class Movie < ActiveRecord::Base
    def Movie.all_ratings
        Array['G','PG','PG-13','R']
    end
    
end
