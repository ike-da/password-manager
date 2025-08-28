#!/bin/bash

echo "パスワードマネージャーへようこそ"

while true
do
    echo "次の選択肢から入力してください(Add Password/Get Password/Exit)："
    read mode

    case "$mode" in
        "Add Password")
            echo "サービス名を入力してください："
            read service

            echo "ユーザー名を入力してください："
            read user

            echo "パスワードを入力してください："
            read pass

            echo "service=\"$service\" user=\"$user\" pass=\"$pass\"" >> data.log

            echo "パスワードの追加は成功しました。Thank you!"
            break
        ;;

        "Get Password")
            #grep "

            break
        ;;

        "Exit")

            break
        ;;
        
        *)
        ;;
    esac
done
