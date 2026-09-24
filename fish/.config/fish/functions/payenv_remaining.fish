# Prints the time left in the payau SSO session, e.g. "7h34m", or "expired".
# AWS keeps no login time on disk, so `payenv login` records one in
# ~/.aws/sso/payenv-login-at. Session length is 8h unless PAYENV_SSO_HOURS says otherwise.
#
#   payenv_remaining          plain text
#   payenv_remaining --color  fish colors, for the prompt
#   payenv_remaining --tmux   tmux #[fg=...] styles, for status-right
function payenv_remaining -d "time left in the AWS SSO login session"
    # the CLI names the cache file after the sha1 of the sso-session name, "payau"
    set -l cache ~/.aws/sso/cache/e88775e87e178e1c8ae2cd125ee07c57d829ffe9.json
    set -l stamp ~/.aws/sso/payenv-login-at
    test -f $cache; and test -f $stamp; or return 1

    set -l hours 8
    set -q PAYENV_SSO_HOURS; and set hours $PAYENV_SSO_HOURS
    set -l left (math (string trim <$stamp) + $hours \* 3600 - (date +%s))

    set -l text expired
    if test $left -gt 0
        set -l h (math --scale 0 floor $left / 3600)
        set -l m (math --scale 0 floor $left % 3600 / 60)
        set text {$m}m
        test $h -gt 0; and set text {$h}h{$m}m
    end

    set -l level ok
    test $left -le 1800; and set level low
    test $left -le 0; and set level out

    switch "$argv[1]"
        case --color
            switch $level
                case ok
                    set_color green
                case low
                    set_color yellow
                case out
                    set_color red
            end
            echo -n $text
            set_color normal
        case --tmux
            # catppuccin mocha green / yellow / red
            switch $level
                case ok
                    echo -n "#[fg=#a6e3a1]"
                case low
                    echo -n "#[fg=#f9e2af]"
                case out
                    echo -n "#[fg=#f38ba8]"
            end
            echo -n "aws $text "
        case '*'
            echo $text
    end
end
