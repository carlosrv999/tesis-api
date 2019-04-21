#!/bin/bash
appname=$1
cd ..
curl -X POST \
          https://api.github.com/user/repos \
            -H 'Authorization: Basic Y2FybG9zcnY5OTk6Q2FybGl0b3MxMSE=' \
              -H 'Content-Type: application/json' \
                -H 'cache-control: no-cache' \
                  -d "{
        \"name\": \"$appname\"
}"
git clone git@github.com:carlosrv999/lb-test.git $appname
cd $appname
rm -rf .git
sed -i "2s/.*/  \"name\": \"${appname}\",/" package.json
git init
git remote add origin git@github.com:carlosrv999/$appname.git
git add .
git commit -m "first commit"
git push origin master
cd ..
rm -rf $appname