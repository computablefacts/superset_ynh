#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================

version_tag='3.0.0'

#=================================================
# PERSONAL HELPERS
#=================================================

change_or_create_var_in_file () {
    # Declare an array to define the options of this helper.
    local legacy_args=fkva
    local -A args_array=([f]=file= [k]=key= [v]=value= [a]=after=)
    local file
    local key
    local value
    local after
    # Manage arguments with getopts
    ynh_handle_getopts_args "$@"

    current_value=$(ynh_read_var_in_file --file="$file" --key="$key")
    if [ "$current_value" = "YNH_NULL" ]; then
        echo "$key=$value" >> $file
    else
        ynh_write_var_in_file --file="$file" --key="$key" --value="$value"
    fi
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

#-------------------------------------------------
# Change ynh_local_curl to return the answer body
# and to set an optional request method and Bearer
#-------------------------------------------------
# Curl abstraction to help with POST requests to local pages (such as installation forms)
#
# usage: ynh_local_curl "method" "bearer" "page_uri" "key1=value1" "key2=value2" ...
# | arg: method      - HTTP request method. POST if empty ("").
# | arg: bearer      - Authorization Bearer. Not sent if empty ("").
# | arg: page_uri    - Path (relative to `$path_url`) of the page where POST data will be sent
# | arg: key1=value1 - (Optionnal) POST key and corresponding value
# | arg: key2=value2 - (Optionnal) Another POST key and corresponding value
# | arg: ...         - (Optionnal) More POST keys and values
#
# example: ynh_local_curl "/install.php?installButton" "foo=$var1" "bar=$var2"
#
# For multiple calls, cookies are persisted between each call for the same app
#
# `$domain` and `$path_url` should be defined externally (and correspond to the domain.tld and the /path (of the app?))
#
# Requires YunoHost version 2.6.4 or higher.
#-------------------------------------------------
ynh_local_curl_extended() {
    # Define url of page to curl
    local local_page=$(ynh_normalize_url_path $1)
    local full_path=$path_url$local_page

    if [ "${path_url}" == "/" ]; then
        full_path=$local_page
    fi

    local full_page_url=https://localhost$full_path

    # Read request method
    local request_method=$2
    if [ "$request_method" = "" ]; then
        request_method="POST"
    fi
    ynh_print_info "request_method=$request_method"

    # Read Bearer
    local bearer=$3

    # Concatenate all other arguments with '&' to prepare POST data
    local POST_data=""
    local arg=""
    for arg in "${@:4}"; do
        POST_data="${POST_data}${arg}&"
    done
    if [ -n "$POST_data" ]; then
        # Add --data arg and remove the last character, which is an unecessary '&'
        POST_data="--data ${POST_data::-1}"
    fi

    # Wait untils nginx has fully reloaded (avoid curl fail with http2)
    sleep 2

    local cookiefile=/tmp/ynh-$app-cookie.txt
    touch $cookiefile
    chown root $cookiefile
    chmod 700 $cookiefile

    # Temporarily enable visitors if needed...
    local visitors_enabled=$(ynh_permission_has_user "main" "visitors" && echo yes || echo no)
    if [[ $visitors_enabled == "no" ]]; then
        ynh_permission_update --permission "main" --add "visitors"
    fi

    # Curl the URL
    local curl_answer=""
    if [ -n "$bearer" ]; then
        curl_answer=$(curl -X $request_method --show-error --insecure --location --header "Host: $domain" --header "Authorization: Bearer $bearer" --resolve $domain:443:127.0.0.1 $POST_data "$full_page_url" --cookie-jar $cookiefile --cookie $cookiefile)
    else
        curl_answer=$(curl -X $request_method --silent --show-error --insecure --location --header "Host: $domain" --resolve $domain:443:127.0.0.1 $POST_data "$full_page_url" --cookie-jar $cookiefile --cookie $cookiefile)
    fi


    if [[ $visitors_enabled == "no" ]]; then
        ynh_permission_update --permission "main" --remove "visitors"
    fi

    echo "$curl_answer"
}

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
