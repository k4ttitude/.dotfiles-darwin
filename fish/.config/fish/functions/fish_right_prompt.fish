function fish_right_prompt
    set -q AWS_PROFILE; or return
    set_color brblack
    echo -n "$AWS_PROFILE "
    set_color normal
    payenv_remaining --color
end
