def get_command_line_argument
    
    if ARGV.empty?
      puts "Usage: ruby lookup.rb <domain>"
      exit
    end
    ARGV.first
  end

  # `domain` contains the domain name we have to look up.
  domain = get_command_line_argument

  # File.readlines reads a file and returns an
  # array of string, where each element is a line
  # https://www.rubydoc.info/stdlib/core/IO:readlines
  dns_raw = File.readlines("zone")
  # ..
  # ..
  def dns_res(dnsdata)
    # remove # symbol from the zone file
    dnsdata = dnsdata.map(&:strip).delete_if {|text_data| text_data.length == 0 }
    dnsdata=dnsdata[1..-1]
    temp_data=Array.new(5){Array.new(3)}
    rows_data=[]
       for r in 0..4
           rows_data=dnsdata[r].strip.split(",")
            for c in 0..2
               temp_data[r][c]=rows_data[c].strip
            end
       end
    Hash[temp_data.map {|key1,x1,x2| [x1,{:type=>key1,:target=>x2}]}]
  end

  def resolve(dns_records, lookup_chain, domain)
      record = dns_records[domain]
      if (!record)
        lookup_chain=["Error: Record not found for #{domain}"]
        return lookup_chain
      elsif record[:type] == "CNAME"
        lookup_chain.push(record[:target])
        resolve(dns_records,lookup_chain,record[:target])
      elsif record[:type] == "A"
        lookup_chain.push(record[:target])
        return lookup_chain
      end
  end

  # ..
  # ..

  # To complete the assignment, implement `parse_dns` and `resolve`.
  # Remember to implement them above this line since in Ruby
  # you can invoke a function only after it is defined.
  dns_records = dns_res(dns_raw)
  lookup_chain = [domain]
  lookup_chain = resolve(dns_records, lookup_chain, domain)
  puts lookup_chain.join(" => ")
