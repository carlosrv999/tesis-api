#!/bin/bash
date -u
appname=$1
cd ..
#Create git repo
echo "Creating Git Repo"
curl -X POST \
  https://api.github.com/user/repos \
            -H "Authorization: Basic $GITHUB_BASIC_AUTH" \
            -H 'Content-Type: application/json' \
            -H 'cache-control: no-cache' \
            -d "{
        \"name\": \"$appname\"
}"
echo "Creating push hook in repo"
curl -X POST \
  https://api.github.com/repos/$GITHUB_USER/$appname/hooks \
  -H "Authorization: Basic $GITHUB_BASIC_AUTH" \
  -H 'Content-Type: application/json' \
  -H 'cache-control: no-cache' \
  -d "{
	\"events\": [
		\"push\"
	],
	\"config\": {
		\"url\": \"$JENKINS_URL/github-webhook/\",
		\"content_type\": \"json\"
	}
	
}"
git clone git@github.com:$GITHUB_USER/lb-test.git $appname
cd $appname
rm -rf .git
sed -i "2s/.*/  \"name\": \"${appname}\",/" package.json
git init
git remote add origin git@github.com:$GITHUB_USER/$appname.git
git add .
git commit -m "first commit"
git push origin master
cd ..
rm -rf $appname