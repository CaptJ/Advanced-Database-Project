conn = PGconn.connect(
    :host => "localhost",   :port => 5432,      :dbname => "DSConnect",
    :user => "lem",         :password => "s"
    )

class PGresult
    def to_h(key_field='id')
        the_h = Hash.new

        self.each do |row|
            the_h[row[key_field]] = row
        end

        the_h
     end

     def to_a
        the_a = Array.new

        self.each do |row|
            the_a << row
        end

        the_a
     end

     def to_json(*a)
        self.to_a.to_json(*a)
     end
end
