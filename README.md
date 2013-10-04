# Prime muliplication table

## Getting Started

This project is relatively self-contained, making minimal use of external requirements. `Thor` is used to make it easier to package the main file to run off the console, `rspec` and `simplecov` were nice to have for testing.


To list commands:

```bash
ruby prime_table.rb
```

To use:

```bash
ruby prime_table.rb print_table 10
```

Example:

```bash
ruby prime_table.rb print_table 10
=> "1  2 3 5 7 11  13  17  19  23  29"
...
```

## Development Considerations

* Learned about [Sieve of Eratosthenes](http://en.wikipedia.org/wiki/Sieve_of_Eratosthenes) before but I stumbled across this: [Sieve of Atkin](http://en.wikipedia.org/wiki/Sieve_of_Atkin). It looked fairly promising and judging by the runtime analysis it should compare fairly well.
* Juding by the tests, against stdlib's Prime class, my code does run... slower! Looking at the internals, there's lots of cleverness that obviously optimized for speed, not so much for legibility. However, to show that scaling isn't an issue, I've made it so that the Atkin implementation can start at any positive offset as for a prime number search starting point. This can easily be used to turn the problem into a map-reduce job (and if you really wanted to, the Atkin class can probably be extend to take a upper bound limit for the search space as well) to become much more scalable. The offset version of Atkin probably can't be used without considering previous solutions since it'd likely return some composite primes but that's understandable if you remove that part of the search space.
* Having the Atkin class be an enumerable allows it search for as long as it needs to without setting arbitrary limits on the search space. The more prime numbers that you do attempt to fetch in one go, however, increases space usage.
* The table implementation was done with an array of arrays, with a top left entry of "1" to make things easy for identity multiplication. The output is tab delimited due to the different length of the numbers which would need to be revisited if very large numbers are printed and offset the natural tab spacing.
* If the table implementation were to be modified to print different subtables of a much larger multiplication table, then I would modify the internals of the table code to use more of the options from the matrix library. Reason for not doing so already is to be able to clearly implement the current solution with some kind of memoized caching for the mulitplication pieces, which saves a fair amount of work since the table/matrix is symmetrical.
* Testing was interesting. Yes the instructions says not to use the Prime class but i'm guessing that's for implementation. Capturing `stdout` required some hacking inside the spec test but seemed reasonable instead of bringing in another gem for this case.
* Made a decision about not dealing with input <= 0, or non-integer inputs and printing nothing, instead of raising some kind of error. `ruby prime_table.rb help print_table`
