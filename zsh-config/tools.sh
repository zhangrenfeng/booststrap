source "$HOME/.bootstrap/colorful.sh"

function epurlencode()
{
    output=$(curl -s https://raw.githubusercontent.com/bestswifter/my-workflow/1f2b0da836d8335f207a9097ecac69d52b4afaa4/url/urlencode.py | python - $1)
    echo_blue "$1"
    echo_yellow "--->"
    echo_green $output
    echo -n $output | pbcopy
}

function epurldecode()
{
    output=$(curl -s https://raw.githubusercontent.com/bestswifter/my-workflow/1f2b0da836d8335f207a9097ecac69d52b4afaa4/url/urldecode.py | python - $1)
    echo_blue "$1"
    echo_yellow "--->"
    echo_green "$output"
    echo -n $output | pbcopy
}