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
        \"name\": \"$GITHUB_REPO_PREFIX-$appname\"
}"
echo "Creating push hook in repo"
curl -X POST \
  https://api.github.com/repos/$GITHUB_USER/$GITHUB_REPO_PREFIX-$appname/hooks \
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
git clone git@github.com:$GITHUB_USER/$GITHUB_MAIN_BPNODEMONGO_REPO.git $appname
cd $appname
rm -rf .git
sed -i "2s/.*/  \"name\": \"${appname}\",/" package.json
printf "# $appname\nNew Boilerplate app" > README.md
git init
git remote add origin git@github.com:$GITHUB_USER/$GITHUB_REPO_PREFIX-$appname.git
git add .
git commit -m "first commit"
git push origin master
cd ..
rm -rf $appname