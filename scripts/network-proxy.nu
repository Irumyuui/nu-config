# From https://github.com/starlight02/Nushell-Proxy-Configuration

# Proxy management functions
# These functions allow manual control of proxy settings

# Helper function to check if a port is listening (cross-platform)
def check-port-listening [port: int] {
    if ($nu.os-info.name == "windows") {
        try {
            # Use cmd /c to handle binary output properly on Windows
            let netstat_output = (cmd /c $"netstat -an | findstr :($port)" | complete)
            ($netstat_output.exit_code == 0) and (($netstat_output.stdout | str length) > 0)
        } catch {
            false
        }
    } else {
        # macOS/Linux using lsof
        try {
            let lsof_output = (lsof -i $":($port)" | complete)
            ($lsof_output.exit_code == 0) and (($lsof_output.stdout | str length) > 0)
        } catch {
            false
        }
    }
}

# Check current proxy status
export def proxy-status [] {
    let http_proxy = ($env.HTTP_PROXY? | default "")

    if ($http_proxy != "") {
        print $"🌐 Current proxy: ($http_proxy)"

        # Test if the proxy is actually working
        let test_result = try {
            (curl -s --connect-timeout 3 --max-time 5 --proxy $http_proxy --head "http://www.google.com" | complete)
        } catch {
            { exit_code: 1 }
        }

        if ($test_result.exit_code == 0) {
            print "✅ Proxy is working"
        } else {
            print "❌ Proxy appears to be down"
        }
    } else {
        print "🔗 Direct connection (no proxy configured)"
    }
}

# Manually enable proxy by detecting available proxy servers
export def proxy-on [] {
    # Common proxy ports (Windows-friendly)
    let common_proxy_ports = if ($nu.os-info.name == "windows") {
        [7890, 1080, 8080, 3128, 1087, 10809]  # More Windows proxy software ports
    } else {
        [7890, 1080]  # Original macOS ports
    }
    mut proxy_found = false

    print "🔍 Scanning for available proxy servers..."

    for port in $common_proxy_ports {
        if not $proxy_found {
            # Check if port is listening using helper function
            if (check-port-listening $port) {
                let proxy_url = $"http://127.0.0.1:($port)"
                print $"🔍 Found service on port ($port), testing connectivity..."

                # Test proxy connectivity
                let proxy_test = try {
                    (curl -s --connect-timeout 3 --max-time 5 --proxy $proxy_url --head "http://www.google.com" | complete)
                } catch {
                    { exit_code: 1 }
                }

                if ($proxy_test.exit_code == 0) {
                    # Set proxy environment variables
                    $env.HTTP_PROXY = $proxy_url
                    $env.HTTPS_PROXY = $proxy_url
                    $env.http_proxy = $proxy_url
                    $env.https_proxy = $proxy_url
                    $env.ALL_PROXY = $proxy_url
                    $env.all_proxy = $proxy_url

                    print $"✅ Proxy enabled: ($proxy_url)"
                    $proxy_found = true
                } else {
                    print $"❌ Proxy on port ($port) is not working"
                }
            }
        }
    }

    if not $proxy_found {
        print "❌ No working proxy found on common ports"
        print "💡 Make sure your proxy software (like Clash, V2Ray, etc.) is running"
    }
}

# Disable proxy
export def proxy-off [] {
    $env.HTTP_PROXY = ""
    $env.HTTPS_PROXY = ""
    $env.http_proxy = ""
    $env.https_proxy = ""
    $env.ALL_PROXY = ""
    $env.all_proxy = ""

    print "🚫 Proxy disabled - using direct connection"
}

# Toggle proxy on/off
export def proxy-toggle [] {
    let current_proxy = ($env.HTTP_PROXY? | default "")

    if ($current_proxy != "") {
        proxy-off
    } else {
        proxy-on
    }
}

# Force re-detection of proxy (useful when proxy software starts after Nushell)
export def proxy-detect [] {
    print "🔄 Re-detecting proxy configuration..."
    proxy-off
    proxy-on
}

# Set custom proxy manually
export def proxy-set [proxy_url: string] {
    print $"🔧 Setting custom proxy: ($proxy_url)"

    # Test the custom proxy
    let test_result = try {
        (curl -s --connect-timeout 3 --max-time 5 --proxy $proxy_url --head "http://www.google.com" | complete)
    } catch {
        { exit_code: 1 }
    }

    if ($test_result.exit_code == 0) {
        $env.HTTP_PROXY = $proxy_url
        $env.HTTPS_PROXY = $proxy_url
        $env.http_proxy = $proxy_url
        $env.https_proxy = $proxy_url
        $env.ALL_PROXY = $proxy_url
        $env.all_proxy = $proxy_url

        print "✅ Custom proxy set and tested successfully"
    } else {
        print "❌ Custom proxy is not working or unreachable"
        print "💡 Please check the proxy URL and ensure the service is running"
    }
}

# Cross-platform proxy software detection and auto-setup at startup
def detect-proxy-software [] {
    try {
        if ($nu.os-info.name == "windows") {
            # Check for common Windows proxy software - use port detection instead of process detection
            let common_proxy_ports = [7890, 1080, 8080, 3128, 1087, 10809]
            mut proxy_detected = false
            mut detected_port = 0

            for port in $common_proxy_ports {
                if (check-port-listening $port) {
                    print $"🪟 Windows proxy service detected on port ($port)"
                    $proxy_detected = true
                    $detected_port = $port
                    break
                }
            }

            if $proxy_detected {
                # Auto-apply the proxy
                let proxy_url = $"http://127.0.0.1:($detected_port)"

                # Test the proxy before applying
                let proxy_test = try {
                    (curl -s --connect-timeout 3 --max-time 5 --proxy $proxy_url --head "http://www.google.com" | complete)
                } catch {
                    { exit_code: 1 }
                }

                if ($proxy_test.exit_code == 0) {
                    print $"✅ Proxy auto-enabled: ($proxy_url)"
                    return $proxy_url
                } else {
                    print $"⚠️ Proxy on port ($detected_port) detected but not working, use 'proxy-on' to test manually"
                }
            }
        } else {
            # macOS/Linux - use port detection instead of process detection for reliability
            let common_proxy_ports = [7890, 1080]
            mut proxy_detected = false
            mut detected_port = 0

            for port in $common_proxy_ports {
                if (check-port-listening $port) {
                    print $"🐧 macOS/Linux proxy service detected on port ($port)"
                    $proxy_detected = true
                    $detected_port = $port
                    break
                }
            }

            if $proxy_detected {
                # Auto-apply the proxy
                let proxy_url = $"http://127.0.0.1:($detected_port)"

                # Test the proxy before applying
                let proxy_test = try {
                    (curl -s --connect-timeout 3 --max-time 5 --proxy $proxy_url --head "http://www.google.com" | complete)
                } catch {
                    { exit_code: 1 }
                }

                if ($proxy_test.exit_code == 0) {
                    print $"✅ Proxy auto-enabled: ($proxy_url)"
                    return $proxy_url
                } else {
                    print $"⚠️ Proxy on port ($detected_port) detected but not working, use 'proxy-on' to test manually"
                }
            }
        }
    } catch {
        # Silently handle proxy detection errors
    }
    return ""
}

# Run proxy software detection and set environment variables globally
try {
    let detected_proxy = (detect-proxy-software)
    if ($detected_proxy != "") {
        $env.HTTP_PROXY = $detected_proxy
        $env.HTTPS_PROXY = $detected_proxy
        $env.http_proxy = $detected_proxy
        $env.https_proxy = $detected_proxy
        $env.ALL_PROXY = $detected_proxy
        $env.all_proxy = $detected_proxy
    }
} catch {
    # Silently handle proxy detection errors
}

# Show proxy management help message
try {
    let current_proxy = ($env.HTTP_PROXY? | default "")
    if ($current_proxy != "") {
        print "💡 Proxy active. Available commands: 'proxy-status', 'proxy-off', 'proxy-toggle', 'proxy-detect', 'proxy-set <url>'"
    } else {
        print "💡 Available proxy commands: 'proxy-status', 'proxy-on', 'proxy-off', 'proxy-toggle', 'proxy-detect', 'proxy-set <url>'"
    }
} catch {
    # Silently handle proxy status errors
}
