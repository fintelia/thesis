exec 2>/dev/null

version=$(git rev-parse HEAD)

if [ $? -eq 0 ]; then
    if [[ -n $(git ls-files --other --exclude-standard :/) ]] || # untracked
        ! git diff --quiet || # modified
        ! git diff --cached --quiet ; then # staged
        version="$version*"
    fi
else
    version="unknown"
fi

version="\\newcommand*{\\version}{$version}"

version_old=$(cat $1)

if [ ! "$version" = "$version_old" ]; then
    printf '%s' "$version" > $1
fi
