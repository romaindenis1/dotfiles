while true; do
    active_ws=$(hyprctl workspaces | grep "Workspace" | grep focused | awk '{print $3}')
    all_ws=$(hyprctl workspaces | grep "Workspace" | awk '{print $3}' | xargs)

    output=""
    for ws in $all_ws; do
        if [[ "$ws" == "$active_ws" ]]; then
            output+="[${ws}] "
        else
            output+="${ws} "
        fi
    done

    echo "{\"text\": \"$output\"}"
    sleep 2
done

