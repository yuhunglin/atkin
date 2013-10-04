class Atkin
  include Enumerable

  def initialize(lower_bound=nil)
    @primes = []

    @lower_bound = lower_bound
    @first_set = %w(1 13 17 29 37 41 49 53).map(&:to_i)
    @second_set = %w(7 19 31 43).map(&:to_i)
    @third_set = %w(11 23 47 59).map(&:to_i)
  end

  def each
    # Basic primes
    %w(2 3 5).map(&:to_i).each do |prime|
      yield prime unless (@lower_bound && @lower_bound > prime)
      @primes << prime
    end
    if (@lower_bound)
      @lower_bound = [@lower_bound, @primes[-1]+1].max
    end

    while true do
      candidate ||= @lower_bound || @primes[-1]+1
      remainder = candidate % 60

      candidate_is_prime ||= false
      if @first_set.include?(remainder)
        candidate_is_prime = first_quadratic_form(candidate)
      elsif @second_set.include?(remainder)
        candidate_is_prime = second_quadradic_form(candidate)
      elsif @third_set.include?(remainder)
        candidate_is_prime = third_quadradic_form(candidate)
      end

      if candidate_is_prime && !has_prime_divisor?(candidate)
        yield candidate
        @primes << candidate
      end
      candidate += 1
    end
  end

  def has_prime_divisor?(candidate)
    @primes.any? { |prime| candidate % prime == 0 }
  end

  def first_quadratic_form(n)
    candidate_is_prime = false
    x_limit = n >> 2
    for x in (1..x_limit)
      break if ((memoized_x = 4*x**2) && (memoized_x >= n))
      for y in (1..n)
        break if ((memoized_y = y**2) && (memoized_y >= n))
        candidate = memoized_x + memoized_y
        next unless (candidate == n)
        if ((candidate%12 == 1) || (candidate%12 == 5))
          candidate_is_prime = !candidate_is_prime
        end
      end
    end
    candidate_is_prime
  end

  def second_quadradic_form(n)
    candidate_is_prime = false
    x_limit = n >> 1
    for x in (1..x_limit)
      break if ((memoized_x = 3*x**2) && (memoized_x >= n))
      for y in (1..n)
        break if ((memoized_y = y**2) && (memoized_y >= n))
        candidate = memoized_x + memoized_y
        next unless (candidate == n)
        if (candidate%12 == 7)
          candidate_is_prime = !candidate_is_prime
        end
      end
    end
    candidate_is_prime
  end

  def third_quadradic_form(n)
    candidate_is_prime = false
    for x in (1..n)
      break if (x**2 >= n)
      for y in (1...x)
        candidate = 3*x**2 - y**2
        next unless candidate == n
        if candidate > 0 && candidate%12 == 11
          candidate_is_prime = !candidate_is_prime
        end
      end
    end
    candidate_is_prime
  end
end