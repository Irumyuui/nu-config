module completions {

  # Generates and tests parsers
  export extern tree-sitter [
    --help(-h)                # Print help
    --version(-V)             # Print version
  ]

  # Generate a default config file
  export extern "tree-sitter init-config" [
    --help(-h)                # Print help
  ]

  # Initialize a grammar repository
  export extern "tree-sitter init" [
    --update(-u)              # Update outdated files
    --grammar-path(-p): path  # The path to the tree-sitter grammar directory
    --help(-h)                # Print help
  ]

  # Generate a parser
  export extern "tree-sitter generate" [
    --log(-l)                 # Show debug log during generation
    --abi: string             # Select the language ABI version to generate (default 15). Use --abi=latest to generate the newest supported version (15).
    --no-parser               # Only generate `grammar.json` and `node-types.json`
    --build(-b)               # Deprecated: use the `build` command
    --debug-build(-0)         # Deprecated: use the `build` command
    --libdir: path            # Deprecated: use the `build` command
    --output(-o): path        # The path to output the generated source files
    --report-states-for-rule: string # Produce a report of the states for the given rule, use `-` to report every rule
    --json                    # Deprecated: use --json-summary
    --json-summary            # Report conflicts in a JSON format
    --js-runtime: string      # The name or path of the JavaScript runtime to use for generating parsers, specify `native` to use the native `QuickJS` runtime
    --disable-optimizations   # Disable optimizations when generating the parser. Currently, this only affects the merging of compatible parse states
    --help(-h)                # Print help
    grammar_path?: path       # The path to the grammar file
  ]

  # Compile a parser
  export extern "tree-sitter build" [
    --wasm(-w)                # Build a Wasm module instead of a dynamic library
    --output(-o): path        # The path to output the compiled file
    --reuse-allocator         # Make the parser reuse the same allocator as the library
    --debug(-0)               # Compile a parser in debug mode
    --help(-h)                # Print help
    path?: path               # The path to the grammar directory
  ]

  def "nu-complete tree-sitter parse debug" [] {
    [ "quiet" "normal" "pretty" ]
  }

  def "nu-complete tree-sitter parse encoding" [] {
    [ "utf8" "utf16-le" "utf16-be" ]
  }

  # Parse files
  export extern "tree-sitter parse" [
    --paths: path             # The path to a file with paths to source file(s)
    --grammar-path(-p): path  # The path to the tree-sitter grammar directory, implies --rebuild
    --lib-path(-l): path      # The path to the parser's dynamic library
    --lang-name: string       # If `--lib-path` is used, the name of the language used to extract the library's language function
    --scope: string           # Select a language by the scope instead of a file extension
    --debug(-d): string@"nu-complete tree-sitter parse debug" # Show parsing debug log
    --debug-build(-0)         # Compile a parser in debug mode
    --debug-graph(-D)         # Produce the log.html file with debug graphs
    --wasm                    # Compile parsers to Wasm instead of native dynamic libraries
    --dot                     # Output the parse data with graphviz dot
    --xml(-x)                 # Output the parse data in XML format
    --cst(-c)                 # Output the parse data in a pretty-printed CST format
    --stat(-s)                # Show parsing statistic
    --timeout: string         # Interrupt the parsing process by timeout (µs)
    --time(-t)                # Measure execution time
    --quiet(-q)               # Suppress main output
    --edits: string           # Apply edits in the format: \"row,col|position delcount insert_text\", can be supplied multiple times
    --encoding: string@"nu-complete tree-sitter parse encoding" # The encoding of the input files
    --open-log                # Open `log.html` in the default browser, if `--debug-graph` is supplied
    --json                    # Deprecated: use --json-summary
    --json-summary(-j)        # Output parsing results in a JSON format
    --config-path: path       # The path to an alternative config.json file
    --test-number(-n): string # Parse the contents of a specific test
    --rebuild(-r)             # Force rebuild the parser
    --no-ranges               # Omit ranges in the output
    --help(-h)                # Print help
    ...paths: path            # The source file(s) to use
  ]

  def "nu-complete tree-sitter test stat" [] {
    [ "all" "outliers-and-total" "total-only" ]
  }

  # Run a parser's tests
  export extern "tree-sitter test" [
    --include(-i): string     # Only run corpus test cases whose name matches the given regex
    --exclude(-e): string     # Only run corpus test cases whose name does not match the given regex
    --file-name: string       # Only run corpus test cases from a given filename
    --grammar-path(-p): path  # The path to the tree-sitter grammar directory, implies --rebuild
    --lib-path(-l): path      # The path to the parser's dynamic library
    --lang-name: string       # If `--lib-path` is used, the name of the language used to extract the library's language function
    --update(-u)              # Update all syntax trees in corpus files with current parser output
    --debug(-d)               # Show parsing debug log
    --debug-build(-0)         # Compile a parser in debug mode
    --debug-graph(-D)         # Produce the log.html file with debug graphs
    --wasm                    # Compile parsers to Wasm instead of native dynamic libraries
    --open-log                # Open `log.html` in the default browser, if `--debug-graph` is supplied
    --config-path: path       # The path to an alternative config.json file
    --show-fields             # Force showing fields in test diffs
    --stat: string@"nu-complete tree-sitter test stat" # Show parsing statistics
    --rebuild(-r)             # Force rebuild the parser
    --overview-only           # Show only the pass-fail overview tree
    --json-summary            # Output the test summary in a JSON format
    --help(-h)                # Print help
  ]

  def "nu-complete tree-sitter version bump" [] {
    [ "patch" "minor" "major" ]
  }

  # Display or increment the version of a grammar
  export extern "tree-sitter version" [
    --grammar-path(-p): path  # The path to the tree-sitter grammar directory
    --bump: string@"nu-complete tree-sitter version bump" # Automatically bump from the current version
    --help(-h)                # Print help (see more with '--help')
    version?: string          # The version to bump to
  ]

  # Fuzz a parser
  export extern "tree-sitter fuzz" [
    --skip(-s): string        # List of test names to skip
    --subdir: path            # Subdirectory to the language
    --grammar-path(-p): path  # The path to the tree-sitter grammar directory, implies --rebuild
    --lib-path: path          # The path to the parser's dynamic library
    --lang-name: string       # If `--lib-path` is used, the name of the language used to extract the library's language function
    --edits: string           # Maximum number of edits to perform per fuzz test
    --iterations: string      # Number of fuzzing iterations to run per test
    --include(-i): string     # Only fuzz corpus test cases whose name matches the given regex
    --exclude(-e): string     # Only fuzz corpus test cases whose name does not match the given regex
    --log-graphs              # Enable logging of graphs and input
    --log(-l)                 # Enable parser logging
    --rebuild(-r)             # Force rebuild the parser
    --help(-h)                # Print help
  ]

  # Search files using a syntax tree query
  export extern "tree-sitter query" [
    --grammar-path(-p): path  # The path to the tree-sitter grammar directory, implies --rebuild
    --lib-path(-l): path      # The path to the parser's dynamic library
    --lang-name: string       # If `--lib-path` is used, the name of the language used to extract the library's language function
    --time(-t)                # Measure execution time
    --quiet(-q)               # Suppress main output
    --paths: path             # The path to a file with paths to source file(s)
    --byte-range: string      # The range of byte offsets in which the query will be executed
    --row-range: string       # The range of rows in which the query will be executed
    --containing-byte-range: string # The range of byte offsets in which the query will be executed. Only the matches that are fully contained within the provided byte range will be returned
    --containing-row-range: string # The range of rows in which the query will be executed. Only the matches that are fully contained within the provided row range will be returned
    --scope: string           # Select a language by the scope instead of a file extension
    --captures(-c)            # Order by captures instead of matches
    --test                    # Whether to run query tests or not
    --config-path: path       # The path to an alternative config.json file
    --test-number(-n): string # Query the contents of a specific test
    --rebuild(-r)             # Force rebuild the parser
    --help(-h)                # Print help
    query_path: path          # Path to a file with queries
    ...paths: path            # The source file(s) to use
  ]

  # Highlight a file
  export extern "tree-sitter highlight" [
    --html(-H)                # Generate highlighting as an HTML document
    --css-classes             # When generating HTML, use css classes rather than inline styles
    --check                   # Check that highlighting captures conform strictly to standards
    --captures-path: path     # The path to a file with captures
    --query-paths: path       # The paths to files with queries
    --scope: string           # Select a language by the scope instead of a file extension
    --time(-t)                # Measure execution time
    --quiet(-q)               # Suppress main output
    --paths: path             # The path to a file with paths to source file(s)
    --grammar-path(-p): path  # The path to the tree-sitter grammar directory, implies --rebuild
    --config-path: path       # The path to an alternative config.json file
    --test-number(-n): string # Highlight the contents of a specific test
    --rebuild(-r)             # Force rebuild the parser
    --help(-h)                # Print help
    ...paths: path            # The source file(s) to use
  ]

  # Generate a list of tags
  export extern "tree-sitter tags" [
    --scope: string           # Select a language by the scope instead of a file extension
    --time(-t)                # Measure execution time
    --quiet(-q)               # Suppress main output
    --paths: path             # The path to a file with paths to source file(s)
    --grammar-path(-p): path  # The path to the tree-sitter grammar directory, implies --rebuild
    --config-path: path       # The path to an alternative config.json file
    --test-number(-n): string # Generate tags from the contents of a specific test
    --rebuild(-r)             # Force rebuild the parser
    --help(-h)                # Print help
    ...paths: path            # The source file(s) to use
  ]

  # Start local playground for a parser in the browser
  export extern "tree-sitter playground" [
    --quiet(-q)               # Don't open in default browser
    --grammar-path: path      # Path to the directory containing the grammar and Wasm files
    --export(-e): path        # Export playground files to specified directory instead of serving them
    --help(-h)                # Print help
  ]

  # Print info about all known language parsers
  export extern "tree-sitter dump-languages" [
    --config-path: path       # The path to an alternative config.json file
    --help(-h)                # Print help
  ]

  def "nu-complete tree-sitter complete shell" [] {
    [ "bash" "elvish" "fish" "power-shell" "zsh" "nushell" ]
  }

  # Generate shell completions
  export extern "tree-sitter complete" [
    --shell(-s): string@"nu-complete tree-sitter complete shell" # The shell to generate completions for
    --help(-h)                # Print help
  ]

}

export use completions *
