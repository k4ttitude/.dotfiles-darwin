complete -c payenv -f
complete -c payenv -n __fish_is_first_arg -a "(string replace -rf '^\[profile\s+(\S+)\s*\]\$' '\$1' <~/.aws/config 2>/dev/null)" -d profile
complete -c payenv -n __fish_is_first_arg -a unset -d 'clear AWS_PROFILE'
complete -c payenv -n __fish_is_first_arg -a login -d 'aws sso login, start the countdown'
complete -c payenv -n __fish_is_first_arg -a logout -d 'aws sso logout'
