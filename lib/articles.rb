require "sequel"

class Articles
  def all
    db[:articles].all
  end

  def db
    Sequel.connect(ENV.fetch("DATABASE_URL"))
  end
end
