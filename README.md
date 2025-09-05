# notebook
This repo is a template to create new repository based on jekyll for github pages

**table of contents**
- [notebook](#notebook)
- [Getting started](#getting-started)
- [Running on local](#running-on-local)
- [Troubleshooting](#troubleshooting)
  - [Port already used](#port-already-used)
- [Useful git commands](#useful-git-commands)
- [Table of contents](#table-of-contents)


# Getting started
1. Create new repo using this template `Use this template` -> `Create a new repository`.
2. Follow the steps for initial [setup](setup.md)

# Running on local
1. start server - `sh scripts/localhost.sh --start`
   1. This will open chrome browser or you can visit [localhost:9999/my_repo_name](http://localhost:9999/my_repo_name)
   2. Initially, you will see error page `This site can’t be reached`
   3. after some time when container has started, you will see the site running
2. stop server - `sh scripts/localhost.sh --stop`

# Troubleshooting

Official documentation for jekyll is [here](https://jekyllrb.com/)

## Port already used
```bash
# find process_id using the port
netstat -vanp tcp | grep 9999
# kill the process based on process_id
kill -9 <PROCESS_ID>
```

# Useful git commands

```
git fetch --all -p; git pull; git status;
git merge origin/main;
git push;
```

# Table of contents

```md
<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>
```