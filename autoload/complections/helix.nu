export extern "hx" [
  ...path: path  # Set the input file to use, position can also be specified via file[:row[:col]]
  --help(-h)  # Print help infomation
  --tutor  # Load the tutorial
  --health: string@"nu-complete helix-health-category"  # Check for potential errors in editor setup
  --grammar(-g): string@"nu-complete helix-grammar"  # Fetch or builds tree-sitter grammars listed in languages.toml
  --config(-c): path  # Specify a file to use for configuration
  -v # Increase logging verbosity each use for up to 3 times
  --log: path  # Specify a file to use for logging
  --version(-V) # Print version information
  --vsplit  # Split all given files vertically into different windows
  --hsplit  # Split all given files horizontally into different windows
  --working-dir(-w): path # Specify an initial working directory
]

def "nu-complete helix-grammar" [] {
  [
    "fetch",  # Fetch helix grammar
    "build",  # Build helix grammar
  ]
}

def "nu-complete helix-health-category" [] {
  [
    "languages",
    "clipboard",
    "all",
    "all-languages",
  ]
}

alias helix = hx
