require 'thor'
require './atkin'

class PrimeTable < Thor
  desc "print_table PRIMES", "Print a multiplication table of the first-N PRIMES (default PRIMES=10)"
  def print_table(num_primes=10)
    num_primes = Integer(num_primes.to_s, 10) rescue nil
    return "" unless num_primes && num_primes > 0

    row_of_rows = print_table_internals(num_primes)
    puts row_of_rows.map {|row| row.join("\t")}
  end

  no_commands do
    def print_table_internals(num_primes)
      cache = {}
      identity_row = Atkin.new.first(num_primes)
      identity_row.unshift(1)
      row_of_rows = [] << identity_row

      for row in (1..num_primes)
        row_of_rows << identity_row.enum_for.map do |entry|
          key = (entry < identity_row[row]) ? "#{entry}_#{identity_row[row]}" : "#{identity_row[row]}_#{entry}"
          next cache[key] if cache.has_key?(key)
          cache[key] = entry * identity_row[row]
        end
      end
      row_of_rows
    end
  end
end

PrimeTable.start(ARGV)