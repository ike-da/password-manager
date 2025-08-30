#!/bin/bash
# パスワードを管理するシェルスクリプト

# パスワードの追加
add_password(){
    local in_servicename in_username in_password
    while true; do
        echo "サービス名を入力してください："
        if ! read -r -n 256 -t 300 in_servicename; then
            echo "タイムアウトしました."
            break
        fi

        echo "ユーザー名を入力してください："
        if ! read -r -n 256 -t 300 in_username; then
            echo "タイムアウトしました."
            break
        fi

        echo "パスワードを入力してください："
        if ! read -r -n 256 -t 300 in_password; then
            echo "タイムアウトしました."
            break
        fi
        {
        printf '%s' "Service=$in_servicename"  | base64 | tr -d '\n'
        printf '\n'
        printf '%s' "$in_username"             | base64 | tr -d '\n'
        printf '\n'
        printf '%s' "$in_password"             | base64 | tr -d '\n'
        printf '\n'
        } >> data.log

        echo "パスワードの追加に成功しました。"
        echo ""
        break
    done

}

# パスワードの表示
get_password(){
    local match result search_servicename

    while true; do
        echo "サービス名を入力してください："
        if ! read -r -n 256 -t 300 search_servicename; then
            echo "タイムアウトしました."
            break
        fi
        
        search_servicename=$(printf '%s' "Service=$search_servicename" | base64 | tr -d '\n')

       # printf '%q' "$out_servicename" > out_servicename

        if match=$(grep -x -F -A 2 -- "$search_servicename" data.log); then
            result=$(echo "$match" | sed '/^--$/d')
            echo ""

            while true; do
                read -r out_servicename || break
                read -r out_username    || break
                read -r out_password    || break

                echo "サービス名 :$(printf '%s' "$out_servicename" | base64 -d | cut -c 9-)"
                echo "ユーザー名 :$(printf '%s' "$out_username"    | base64 -d)"
                echo "パスワード :$(printf '%s' "$out_password"    | base64 -d)"
                echo ""
            done <<< "$result"

            break
        else
            echo "そのサービスは登録されていません。"
        fi
    done
}


# main
main(){
    echo ""
    echo "パスワードマネージャーへようこそ"

    #Exitが入力されるまでループする
    while true; do
        echo "次の選択肢から入力してください(Add Password/Get Password/Exit)："
        if ! read -r -n 16 -t 300 mode; then
            echo "タイムアウトしました."
            break
        fi
        # Add Password/Get Password/Exitの処理
        case "$mode" in
            "Add Password")
                add_password;;

            "Get Password")
                get_password;;

            "Exit")
                echo "Thank you!"
                echo""
                #プログラムが終了
                break;;
        # Add Password/Get Password/Exit 以外が入力された場合        
            *)
                echo "入力が間違っています。"
                echo "Add Password/Get Password/Exit から入力してください。"
                echo "";;
        esac
    done
}

main