function __payenv_profiles
    string replace -rf '^\[profile\s+(\S+)\s*\]$' '$1' <~/.aws/config 2>/dev/null
end

function payenv -d "set or clear AWS_PROFILE for this shell"
    switch "$argv[1]"
        case login
            # payenv_remaining counts down from this timestamp
            aws sso login --sso-session payau; or return
            date +%s >~/.aws/sso/payenv-login-at
        case logout
            aws sso logout; or return
            rm -f ~/.aws/sso/payenv-login-at
        case unset none clear
            set -e AWS_PROFILE
            echo "AWS_PROFILE unset"
        case ''
            echo "Usage: payenv <profile|unset|login|logout>"
            echo "Profiles:" (__payenv_profiles)
            return 1
        case '*'
            if not contains -- $argv[1] (__payenv_profiles)
                echo "payenv: no profile '$argv[1]' in ~/.aws/config" >&2
                echo "Profiles:" (__payenv_profiles) >&2
                return 1
            end
            set -gx AWS_PROFILE $argv[1]
            echo "AWS_PROFILE set to: $AWS_PROFILE"
    end
end
